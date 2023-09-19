import { reactive } from 'vue'
import { createStore } from 'vuex'

export const store = createStore({
    state: {
        lands: [],
        connectedAddress: '',
        propertyId: null
    },
    mutations: {
        setConnectedAddress(state, address) {
          state.connectedAddress = address;
        },
        setPropertyId(state, propertyId) {
            state.propertyId = propertyId;
        },
        setLands(state, lands) {
            state.lands = lands;
        }
      },
      actions: {
        updateConnectedAddress({ commit }, address) {
          commit('setConnectedAddress', address);
        }
      },
      getters: {
        getConnectedAddress(state) {
          return state.connectedAddress;
        }
      }
})

