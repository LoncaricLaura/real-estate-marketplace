<template>
    <div
        class="absolute flex justify-between items-center w-full lg:h-auto px-8 sm:px-12 md:px-24 lg:px-32 xl:px-32 pt-4 top-0 lg:top-0 md:pt-8 py-8 font-['Inter'] z-[100]"
    >
        <router-link
            to="/"
            class="flex flex-row items-center pt-6 lg:pt-0 gap-2 lg:gap-6 w-2/3 lg:w-1/5"
        >
            <img
                src="/src/assets/logo.svg"
                alt="logo"
                class="logo h-[80px]"
            />
        </router-link>
        <div class="flex flex-row items-center gap-8">
            <h2 v-if="store.state.connectedAddress" class="text-white text-sm flex items-center font-bold h-[40px] px-6 py-2 bg-[#313131] rounded-lg">Account: <span class="showAccount">{{ store.state.connectedAddress }}</span></h2>
            <div v-if="!store.state.connectedAddress" class="flex items-center text-[##3C3C3C] font-bold h-[50px] px-6 py-2 bg-[#F5BA41] hover:bg-[#FCE44D] rounded-lg cursor-pointer enableEthereumButton">
                Connect wallet
            </div>
        </div>
    </div>
</template>

<script>
import { ref, onMounted } from 'vue';   
import { store } from '/src/store.js'
import { ethers } from 'ethers';
import detectEthereumProvider from '@metamask/detect-provider';

export default {
    name: 'Header',
    data() {
        return {
            store
        }
    },
    setup() {


    const provider = ref(null);
    const signer = ref(null);
    const connectedAddress = ref('');
    const propertyId = ref(0);
    const propertyPrice = ref(0);
    const propertyLocation = ref('');

    const connectMetaMask = async () => {
      const detectedProvider = await detectEthereumProvider();
      if (detectedProvider) {
        provider.value = new ethers.providers.Web3Provider(detectedProvider);

        await detectedProvider.request({ method: 'eth_requestAccounts' });

        signer.value = provider.value.getSigner();
      } else {
        console.error('MetaMask not detected.');
      }
    };
    const getConnectedAddress = async () => {
      if (provider.value) {
        const accounts = await provider.value.listAccounts();
        if (accounts.length > 0) {
          connectedAddress.value = accounts[0];

          store.dispatch('updateConnectedAddress', connectedAddress.value);
        }
      }
    };


    onMounted(async () => {
      await connectMetaMask();
      await getConnectedAddress();

    });

    return {
      connectedAddress,
      propertyId,
      propertyPrice,
      propertyLocation,
      connectMetaMask,
    };
  }
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Bellota+Text&family=Inter&display=swap');
</style>
