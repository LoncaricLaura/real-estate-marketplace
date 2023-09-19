<template>
   <section class="relative w-full h-[500px]">
    <video src="../assets/videos/hero.mp4" muted autoplay loop></video>
   </section>

   <div class="absolute top-[350px] flex flex-row gap-x-8 pt-8 px-8 sm:px-12 md:px-24 lg:px-32 xl:px-32" v-if="store.state.connectedAddress === '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266'" >
        <button class="flex justify-center items-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer w-[200px]" @click="toggleVisible()">Add Property</button>
        <button class="flex justify-center items-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer w-[200px]" @click="toggleVisible2()">Approve</button>
    </div>
    
    <section class="py-16 px-8 sm:px-12 md:px-24 lg:px-32 xl:px-32">
        <EstateCard :lands="landList" />
   </section>

   <section v-if="this.isVisible === true" class="add-overlay">
        <img @click="toggleVisible" src="/src/assets/close.png" class="absolute mt-[-600px] ml-[400px] w-[40px] cursor-pointer">
        <div class="flex flex-col bg-[#444444] w-1/4 h-[650px] p-12 gap-y-12 rounded-md">
            <h2 class="text-xl text-white">Add property</h2>
            <div class="flex justify-between text-white gap-8">
                <label for="location ">Location</label>
                <input type="text" id="location" v-model="location" required>
            </div>
            <div class="flex justify-between text-white gap-8">
                <label for="location ">Name</label>
                <input type="text" id="name" v-model="name" required>
            </div>
            <div class="flex justify-between text-white gap-8">
                <label for="location ">Description</label>
                <input type="text" id="desc" v-model="desc" required>
            </div>
            <div class="flex justify-between text-white text-start gap-8">
                <label for="cost">Cost <br> (in Ether)</label>
                <input type="number" id="cost" v-model="cost" required>
            </div>
            <button class="flex justify-center items-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer" @click="addProperty">Add Property</button>
        </div>
    </section>

    <section v-if="this.isVisible2 === true" class="add-overlay">
        <img @click="toggleVisible2" src="/src/assets/close.png" class="absolute mt-[-400px] ml-[400px] w-[40px] cursor-pointer">
        <div class="flex flex-col bg-[#444444] w-1/4 h-[450px] p-12 gap-y-12 rounded-md">
            <h2 class="text-xl text-white">Approve buyer</h2>
            <div class="flex justify-start text-white text-start gap-8">
                <label for="propertyId">Property id</label>
                <input type="number" id="propertyId" v-model="propertyId" required>
            </div>
            <div class="flex justify-start text-white gap-8">
                <label for="location ">Buyer Address</label>
                <input type="text" id="location" v-model="buyerAddress" required>
            </div>
            <button class="flex justify-center items-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer" @click="approveBuyer">Approve Buyer</button>
        </div>
    </section>
</template>

<script>
import EstateCard from '/src/components/EstateCard.vue'
import data from '/data/estates.json'
import { ethers } from 'ethers'
import { store } from '../store.js'
import contractAbi from '/abi/contracts/RealEstate.sol/RealEstate.json'

export default {
    name: 'homePage',
    components: {
        EstateCard,
    },
    data() {
        return {
            estates: [],
            location: '',
            name: '',
            desc: '',
            cost: '',
            propertyId: '',
            buyerAddress: '',
            property: {},
            store,
            isVisible: false,
            isVisible2: false,
            landList: []
        }
    },
    methods: {
        async getAllLands() {
            const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'; 
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const contract = new ethers.Contract(contractAddress, contractAbi, provider);

            try {
                const totalLands = await contract.totalLandsCounter(); 
                const lands = [];

                for (let i = 1; i <= totalLands; i++) {
                const landDetails = await contract.getLand(i); 
                lands.push({
                    location: landDetails[0],
                    name: landDetails[1],
                    desc: landDetails[2],
                    cost: landDetails[3].toString(), 
                    ownerAddress: landDetails[4].toString(),
                    id: parseFloat(landDetails[5]),
                    wantSell: parseFloat(landDetails[6]),
                });
                }

                this.landList = lands;
                store.commit('setLands', this.landList);
            } catch (error) {
                console.error('Error fetching land list:', error.message);
            }
    },
        async getData() {
            this.estates = data.estates       
        },
        toggleVisible() {
            this.isVisible = !this.isVisible;
        },
        toggleVisible2() {
            this.isVisible2 = !this.isVisible2;
        },
        async addProperty() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            console.log(contractAbi);
            const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
            const contract = new ethers.Contract(contractAddress, contractAbi, signer);
            try {
                const tx = await contract.addLand(this.location, this.name, this.desc, (BigInt(this.cost * 1e18)));
                await tx.wait(); 
                const numOfLands = await contract.totalLandsCounter()
                console.log(parseFloat(numOfLands))

                store.commit('setPropertyId', numOfLands.toNumber());
                console.log('store id:', store.state.propertyIds)
    
                alert('Property added successfully!');
            } catch (error) {
                console.error('Error adding property:', error.message);
                alert('Error adding property. Please try again.');
            }
            window.location.reload();
            this.isVisible = false;
        },
        async approveBuyer() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
            const contract = new ethers.Contract(contractAddress, contractAbi, signer);
            try {
                const tx = await contract.agreeOnApprover(this.propertyId, this.buyerAddress);
                await tx.wait(); 
                
                
                alert(`Buyer ${this.buyerAddress} successfully!`);
            } catch (error) {
                console.error('Error adding property:', error.message);
                alert('Error adding property. Please try again.');
            }
            this.isVisible2 = false;
        },
    },
        mounted() {
        this.getData();
        this.getAllLands();
        console.log(contractAbi);
    },
}
</script>

<style>
video {
    position: relative;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    opacity: 0.45;
}

.add-overlay {
    width: 100%;
	height: 100%;
	inset: 0;
	position: fixed;
	backdrop-filter: blur(10px);
	-webkit-backdrop-filter: blur(10px);
	z-index: 100;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 16px;
}

input {
    background-color: transparent;
    border-bottom: 1px solid;
    color: white;
}
</style>