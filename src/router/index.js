import { createRouter, createWebHistory } from 'vue-router'
import index from '/src/views/index.vue'
import propertyDetails from '/src/views/property-details.vue'

const routes = [
    {
        path: '/',
        name: 'homePage',
        component: index,
        props: true
    },
    {
        path: '/property-details/:id',
        name: 'propertyDetails',
        component: propertyDetails,
        props: true
    },
]
const router = createRouter({
    history: createWebHistory(),
    routes,
})
export default router