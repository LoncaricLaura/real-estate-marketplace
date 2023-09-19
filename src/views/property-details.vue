<template>
    <section class="property-details flex flex-row gap-32 pt-32 px-8 sm:px-12 md:px-24 lg:px-32 xl:px-32 w-full">
        <div class="flex flex-col w-1/2">
            <DetailsSlider :details="estateDetails" class="flex flex-col w-[100%]" />
        </div>
        <div class="flex flex-col items-start p-12 w-full">
            <p class="text-3xl text-[#F5BA41] pb-12">{{ landDetails.name}}</p>
            <p class="text-2xl text-[#F5BA41] pb-12">{{ landDetails.location }}</p>
            <p class="text-2xl text-[#F5BA41] pb-6">{{ cost }} (ETH)</p>
            <p class="text-lg text-start text-white pb-12">{{ landDetails.desc }}</p>
            <p class="text-lg text-start text-white pb-12">Owner: {{ landDetails.ownerAddress }}</p>
            <div @click="buyProperty" class="flex items-center justify-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer w-1/2">
                Buy
            </div>
        </div>
    </section>
</template>

<script>
import DetailsSlider from '/src/components/DetailsSlider.vue'
import data from '/data/estates.json'
import { store } from '../store.js'
import contractAbi from '/abi/contracts/RealEstate.sol/RealEstate.json'
import { ethers } from 'ethers'

export default {
    name: 'propertyDetails',
    components: {
        DetailsSlider
    },
    data() {
        return {
			estateDetails: {},
            landDetails: {},
            store,
            ethers,
            cost: null
        }
    },
    mounted() {
        this.getLandDetails();
        this.cost = ethers.utils.formatEther(this.landDetails.cost)
        console.log(typeof(this.landDetails.cost))
    },
    methods: {
        getLandDetails() {
            let id = this.$route.params.id;

            for (let i = 0; i < store.state.lands.length; i++) {
                if (store.state.lands[i].id.toString() === id) {
                    this.landDetails = store.state.lands[i];
                    console.log(this.landDetails);
                    return;
                }
            }
        },
        async buyProperty() {
            const provider = new ethers.providers.Web3Provider(window.ethereum);
            const signer = provider.getSigner();
            const gasLimit = 3000000
            const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
            const contract = new ethers.Contract(contractAddress, contractAbi, signer);
            try {
                const tx = await contract.approveTransferAsBuyer(this.landDetails.id, {
                    value: this.landDetails.cost,
                    gasLimit: gasLimit,
                    });
                await tx.wait(); 
                
                
                alert(`Buyer ${this.buyerAddress} successfully!`);
            } catch (error) {
                console.error('Error adding property:', error.message);
                alert('Error adding property. Please try again.');
            }
        }
    }
}

</script>

<style>
.property-details {
    position: relative;
    height: 100vw;
    width: 100%;
    background-color: #313131 !important;
}
</style>