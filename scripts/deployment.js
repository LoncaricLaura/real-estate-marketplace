import hardhat from "hardhat";

const { ethers } = hardhat;

async function deploy() {

    const RealEstate = await ethers.getContractFactory('RealEstate');
    const realestate = await RealEstate.deploy();

    await realestate.deployed();

    console.log('RealEstate deployed to:', realestate.address);
}

async function main() {
    try {
        await deploy();
        process.exit(0);
    } catch (e) {
        console.error(e);
        process.exit(0);
    }
}

main(); 