<template>
    <Splide :options="splide" class="splide">
        <SplideSlide
            v-for="(img, i) in images"
            :key="i"
            class="splide__track flex justify-center"
        >
            <ul
                class="splide__list flex flex-row flex-wrap w-screen md:w-[850px] bg-[#FFFAF0]"
            >
                <li
                    class="splide__slide flex flex-col items-center justify-between w-full h-full"
                >
                        <img
                            :src="`${img.img}`"
                            :alt="`${img.img}`"
                            class="flex object-cover"
                        />
                </li>
            </ul>
        </SplideSlide>
    </Splide>

	
    <!-- Thumbnail Slider -->
    <Splide :options="thumbnailSplideOptions" class="thumbnail-slider">
      <SplideSlide
        v-for="(img, i) in images"
        :key="i"
        class="splide__track flex justify-center"
      >
        <img :src="img.img" :alt="img.img" class="flex object-cover" />
      </SplideSlide>
    </Splide>

</template>

<script>
import { Splide, SplideSlide } from '@splidejs/vue-splide'
import '@splidejs/vue-splide/css'
import data from '/data/estates.json'

export default {
    name: 'BlogSlider',
    props: {
        details: {
            type: Object,
            required: true
        }
    }, 
    data() {
        return {
            splide: {
                type: 'loop',
                width: '100%',
                height: '500px',
                perPage: 1,
                arrows: true,
                arrowPath: 'M40 9L25 0.339746V17.6603L40 9ZM26.5 7.5L0 7.5V10.5L26.5 10.5V7.5Z',
                fill: 'none',
                pagination: false,
                rewind: true,
                gap: 0,
                rewindspeed: 5000,
				isNavigation: false,
                breakpoints: {
                    1250: {
                        perPage: 1,
                        width: '100%',
                    },
                    768: {
                        rewind: false,
                        focus: 'center',
                        pagination: 'slider',
                        perMove: 1,
                        arrows: false,
                        width: '100vh',
                        height: '500px',
                    },
                },
            },
			thumbnailSplideOptions: {
				type: 'slide',
				rewind: true,
				perPage: 3, 
				focus: 'center',
				gap: 20, 
				arrows: false,
				width: '100%',
                height: '170px',
				pagination: false,
				isNavigation: true,
				drag: false
			},
			images: [
				{
					img: '/src/assets/estates/villa1.jpeg'
				},
				{
					img: '/src/assets/estates/villa1.png'
				},
				{
					img: '/src/assets/estates/villa3.jpeg'
				},
				{
					img: '/src/assets/estates/villa4.jpeg'
				}
			],
			objectData: {}
        }
    },
    components: {
        Splide,
        SplideSlide,
    },
/* 	mounted() {
        this.fetchObjectData();
        console.log(this.objectData)
    },
    methods: {
        fetchObjectData() {
            let id = this.$route.params.id
            this.objectData = data.blogs.find(obj => obj.id === id);
        }
    } */
}
</script>

<style>
.splide__arrow {
    background: transparent;
}

.splide__arrow svg {
    fill: #EBAC0D;
    height: 3.2rem;
    width: 3.2rem;
}

.splide__arrow--prev {
	left: -55px;
}

.splide__arrow--next {
	right: -55px;
}

.splide.is-focus-in .splide__arrow:focus {
    outline: none;
}

button:focus {
    outline: none;
}

.thumbnail-slider {
  margin-top: 20px; 
}

.splide__track--nav>.splide__list>.splide__slide.is-active {
	/* border: 2px solid #EBAC0D;  */
	border: none;
}

@media (max-width: 768px) {
    .splide-list {
        width: 100%;
    }
}
</style>
