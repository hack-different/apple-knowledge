"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const main_1 = require("../src/main");
test('a file can be loaded', async () => {
    let data = await (0, main_1.getData)('cores');
    expect(data).toBeDefined();
});
