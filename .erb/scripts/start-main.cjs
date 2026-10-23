/**
 * Dev launcher for the Electron main process.
 *
 * Electron >= 28 loads the app entry through the ESM loader, which cannot
 * handle TypeScript files. This CommonJS shim registers ts-node and then
 * loads the real TypeScript entry.
 */
process.env.TS_NODE_TRANSPILE_ONLY = 'true';

require('ts-node').register({
  transpileOnly: true,
  compilerOptions: { module: 'commonjs' },
});

require('../../src/main/main.ts');
