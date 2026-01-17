const chai = require('chai');
const { wasm } = require('circom_tester');
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);
const chaiAsPromised = require("chai-as-promised");
const wasm_tester = require("circom_tester").wasm;

chai.use(chaiAsPromised);
const expect = chai.expect;

describe("SwapArrayElements Test", async function () {
    this.timeout(100000);

    let circuit;

    before(async () => {
        circuit = await wasm_tester(path.join(__dirname, "../SwapArrayElements/", "SwapArrayElements.circom"));
        await circuit.loadConstraints();
    });

    it("should compile and accept basic witnesses for Swap(6)", async () => {
        let witness = await circuit.calculateWitness({ 
            "in": [1, 2, 3, 4, 5, 6], 
            "x": 0, 
            "y": 0 
        }, true);
        await circuit.assertOut(witness, { "out": [1, 2, 3, 4, 5, 6] });

        witness = await circuit.calculateWitness({ 
            "in": [1, 2, 3, 4, 5, 6], 
            "x": 1, 
            "y": 4 
        }, true);
        await circuit.assertOut(witness, { "out": [1, 5, 3, 4, 2, 6] });

    });

    it("should fail if indexes are out of range for Swap(6)", async () => {
        await expect(circuit.calculateWitness({ 
            "in": [10, 20, 30, 40, 50, 60], 
            "x": -1, 
            "y": 7 
        }, true)).to.be.rejected;

        await expect(circuit.calculateWitness({ 
            "in": [1, 2, 3, 4, 5, 6], 
            "x": 0, 
            "y": 7 
        }, true)).to.be.rejected;
    });
});
