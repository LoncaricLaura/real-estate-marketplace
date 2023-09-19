<template>
    <section class="flex flex-row justify-center flex-wrap gap-10">
        <div v-for="estate in lands" :key="estate.location" 
            class="flex flex-col items-start w-[380px] h-[380px] bg-[#424242] rounded-lg shadow-[0_25px_77px_-25px_rgba(0,0,0,0.32)] transition-all duration-500 ease-out hover:scale-[1.05]">
            <img :src="`src/assets/estates/villa1.jpeg`" class="w-full h-[250px]">
            <div class="flex flex-col items-start gap-y-2 p-4">
                <p class="text-white">{{ estate.loaction }}</p>
                <p class="text-white">PRICE: {{ ethers.utils.formatEther(estate.cost) }} ETH</p>
                 <router-link :to="{ name: 'propertyDetails', params: {id: estate.id}}" class="flex items-center text-[#F5BA41] hover:text-[#fac557'] border-none font-bold h-[35px] rounded-lg cursor-pointer">
                    VIEW PROPERTY
                 </router-link>
            </div>
        </div>
    </section>
</template>

<script>
import { ethers } from 'ethers'

export default {
    name: 'EstateCard',
    props: {
        lands: {
            type: Array,
            required: true
        }
    },
    data() {
        return {
            ethers
        }
    }
}
</script>