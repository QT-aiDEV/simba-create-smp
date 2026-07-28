# Stock Market Risk Note - 0.9.34

0.9.34 adds the stable Stock Market stack as a controlled server economy experiment.

## Added Mods

- BankSystem `banksystem-neoforge-1.4.1.jar`
  - CurseForge project `1175370`
  - CurseForge file `6200607`
- Stock Market `stockmarket-neoforge-1.3.1.jar`
  - CurseForge project `1158647`
  - CurseForge file `6200720`

Both are client-and-server mods and were added to Heavy, Lite, and Server.

## Dependency Chain

- Stock Market requires BankSystem `[1.4.0, 1.5.0)`.
- Stock Market requires Architectury API `[13.0.8,)`.
- BankSystem requires Architectury API `[13.0.8,)`.
- Simba already had Architectury API `13.0.8`.

CurseForge's public relations page did not show the BankSystem dependency, but the NeoForge mod metadata does. Keep BankSystem with Stock Market.

## Risk

This should be safer than worldgen or structure mods because it does not add terrain generation. Removing it later should not damage chunks, but placed bank/market blocks and related items will disappear or become missing IDs.

The real risk is data integrity:

- Bank balances
- Stored bank items
- Market orders
- Market configuration
- Market data persistence after restarts

Do not rely on it in the long-term world until it survives a copied-world trial.

## Test Checklist

- Boot a copied server world with both mods.
- Create markets for simple items: logs, iron, copper, dirt.
- Test deposit and withdraw in BankSystem.
- Place buy and sell orders in Stock Market.
- Restart the server twice.
- Confirm balances, stored items, orders, and market prices persist.
- Remove the mods from a copied world and confirm the server still boots.
- Check logs for `Market_data.dat`, bank load/save, or missing dependency errors.
