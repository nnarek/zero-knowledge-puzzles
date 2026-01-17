const chai = require('chai');
const {
    wasm
} = require('circom_tester');
const path = require("path");
const F1Field = require("ffjavascript").F1Field;
const Scalar = require("ffjavascript").Scalar;
exports.p = Scalar.fromString("21888242871839275222246405745257275088548364400416034343698204186575808495617");
const Fr = new F1Field(exports.p);
const chaiAsPromised = require("chai-as-promised");
const wasm_tester = require("circom_tester").wasm;

chai.use(chaiAsPromised);
const expect = chai.expect;

describe("ArraySelect -- Select element from array by index", function() {
    this.timeout(100000);

    let circuit;

    before(async () => {
        circuit = await wasm_tester(path.join(__dirname, "../ArraySelect/", "ArraySelect.circom"));
        await circuit.loadConstraints();
    });

    it("Should return first element when index is 0", async () => {
        let witness = await circuit.calculateWitness({
            "in": [10, 20, 30, 40],
            "index": 0
        }, true);
        let out = witness[1];
        expect(Fr.eq(Fr.e(out), Fr.e(10))).to.be.true;
    });

    it("Should return second element when index is 1", async () => {
        let witness = await circuit.calculateWitness({
            "in": [10, 20, 30, 40],
            "index": 1
        }, true);
        let out = witness[1];
        expect(Fr.eq(Fr.e(out), Fr.e(20))).to.be.true;
    });

    it("Should return last element when index is n-1", async () => {
        let witness = await circuit.calculateWitness({
            "in": [10, 20, 30, 40],
            "index": 3
        }, true);
        let out = witness[1];
        expect(Fr.eq(Fr.e(out), Fr.e(40))).to.be.true;
    });

    it("Should work with different array values", async () => {
        let witness = await circuit.calculateWitness({
            "in": [100, 200, 300, 400],
            "index": 2
        }, true);
        let out = witness[1];
        expect(Fr.eq(Fr.e(out), Fr.e(300))).to.be.true;
    });

    it("Should fail when index is -1", async () => {
        await expect(circuit.calculateWitness({
            "in": [10, 20, 30, 40],
            "index": -1
        }, true)).to.be.rejected;
    });

    it("Should fail when index is out of bounds", async () => {
        await expect(circuit.calculateWitness({
            "in": [10, 20, 30, 40],
            "index": 4
        }, true)).to.be.rejected;
    });

});
