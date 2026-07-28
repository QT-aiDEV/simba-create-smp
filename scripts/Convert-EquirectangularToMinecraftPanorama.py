#!/usr/bin/env python3
"""Convert a 2:1 equirectangular image into Minecraft Java panorama_0..5 cubemap faces."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path

import numpy as np
from PIL import Image


def smoothstep(value: float) -> float:
    return value * value * (3.0 - 2.0 * value)


def close_horizontal_seam(pixels: np.ndarray, blend_fraction: float) -> np.ndarray:
    result = pixels.astype(np.float32).copy()
    width = result.shape[1]
    band = max(2, min(width // 4, int(round(width * blend_fraction))))
    original = result.copy()
    for offset in range(band):
        progress = offset / float(band - 1)
        own_weight = 0.5 + 0.5 * smoothstep(progress)
        left = original[:, offset, :]
        right = original[:, width - 1 - offset, :]
        result[:, offset, :] = own_weight * left + (1.0 - own_weight) * right
        result[:, width - 1 - offset, :] = own_weight * right + (1.0 - own_weight) * left
    return np.clip(result, 0, 255).astype(np.uint8)


def sample_equirectangular(source: np.ndarray, direction: np.ndarray) -> np.ndarray:
    height, width, _ = source.shape
    norm = np.linalg.norm(direction, axis=2)
    x_dir = direction[:, :, 0] / norm
    y_dir = direction[:, :, 1] / norm
    z_dir = direction[:, :, 2] / norm

    longitude = np.arctan2(x_dir, z_dir)
    latitude = np.arcsin(np.clip(y_dir, -1.0, 1.0))
    source_x = np.mod((longitude / (2.0 * math.pi) + 0.5) * width, width)
    source_y = np.clip((0.5 - latitude / math.pi) * (height - 1), 0, height - 1)

    x0 = np.floor(source_x).astype(np.int32)
    y0 = np.floor(source_y).astype(np.int32)
    x1 = (x0 + 1) % width
    y1 = np.minimum(y0 + 1, height - 1)
    wx = (source_x - x0)[:, :, None]
    wy = (source_y - y0)[:, :, None]

    top = source[y0, x0] * (1.0 - wx) + source[y0, x1] * wx
    bottom = source[y1, x0] * (1.0 - wx) + source[y1, x1] * wx
    return np.clip(top * (1.0 - wy) + bottom * wy, 0, 255).astype(np.uint8)


def face_direction(face: int, u: np.ndarray, v: np.ndarray) -> np.ndarray:
    if face == 0:  # north/front
        return np.stack((u, -v, np.ones_like(u)), axis=2)
    if face == 1:  # east/right
        return np.stack((np.ones_like(u), -v, -u), axis=2)
    if face == 2:  # south/back
        return np.stack((-u, -v, -np.ones_like(u)), axis=2)
    if face == 3:  # west/left
        return np.stack((-np.ones_like(u), -v, u), axis=2)
    if face == 4:  # up/ceiling
        return np.stack((u, np.ones_like(u), v), axis=2)
    if face == 5:  # down/floor
        return np.stack((u, -np.ones_like(u), -v), axis=2)
    raise ValueError(f"Unsupported face: {face}")


def rms_difference(first: np.ndarray, second: np.ndarray) -> float:
    delta = first.astype(np.float32) - second.astype(np.float32)
    return float(np.sqrt(np.mean(delta * delta)))


def validate_edges(faces: list[np.ndarray]) -> dict[str, float]:
    checks = {
        "0-right__1-left": (faces[0][:, -1], faces[1][:, 0]),
        "1-right__2-left": (faces[1][:, -1], faces[2][:, 0]),
        "2-right__3-left": (faces[2][:, -1], faces[3][:, 0]),
        "3-right__0-left": (faces[3][:, -1], faces[0][:, 0]),
        "0-top__4-bottom": (faces[0][0, :], faces[4][-1, :]),
        "1-top__4-right-reversed": (faces[1][0, :], faces[4][:, -1][::-1]),
        "2-top__4-top-reversed": (faces[2][0, :], faces[4][0, :][::-1]),
        "3-top__4-left": (faces[3][0, :], faces[4][:, 0]),
        "0-bottom__5-top": (faces[0][-1, :], faces[5][0, :]),
        "1-bottom__5-right": (faces[1][-1, :], faces[5][:, -1]),
        "2-bottom__5-bottom-reversed": (faces[2][-1, :], faces[5][-1, :][::-1]),
        "3-bottom__5-left-reversed": (faces[3][-1, :], faces[5][:, 0][::-1]),
    }
    return {name: round(rms_difference(first, second), 4) for name, (first, second) in checks.items()}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--size", type=int, default=1024)
    parser.add_argument("--seam-blend", type=float, default=0.08)
    args = parser.parse_args()

    image = Image.open(args.source).convert("RGB")
    if image.width != image.height * 2:
        raise SystemExit(f"Source must be exactly 2:1; got {image.width}x{image.height}")
    args.output.mkdir(parents=True, exist_ok=True)

    source = close_horizontal_seam(np.asarray(image), args.seam_blend)
    Image.fromarray(source, "RGB").save(args.output / "panorama_source_seam_closed.png")

    coordinates = np.linspace(-1.0, 1.0, args.size, dtype=np.float32)
    u, v = np.meshgrid(coordinates, coordinates)
    faces: list[np.ndarray] = []
    for face in range(6):
        pixels = sample_equirectangular(source.astype(np.float32), face_direction(face, u, v))
        faces.append(pixels)
        Image.fromarray(pixels, "RGB").save(args.output / f"panorama_{face}.png", optimize=True)

    report = {
        "source": str(args.source),
        "source_dimensions": [image.width, image.height],
        "face_size": args.size,
        "seam_blend_fraction": args.seam_blend,
        "face_order": {
            "panorama_0": "north/front",
            "panorama_1": "east/right",
            "panorama_2": "south/back",
            "panorama_3": "west/left",
            "panorama_4": "up/ceiling",
            "panorama_5": "down/floor",
        },
        "edge_rms": validate_edges(faces),
    }
    (args.output / "panorama-validation.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    worst = max(report["edge_rms"].values())
    print(json.dumps(report, indent=2))
    if worst > 1.0:
        raise SystemExit(f"Cubemap edge validation failed; worst RMS difference was {worst}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
