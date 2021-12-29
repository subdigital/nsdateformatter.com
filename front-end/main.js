import './css/main.css';

import Tabs from './js/tabs.js';

function setupTabs() {
    let tabElements = document.querySelectorAll("nav a[data-target]")
    let selectedTab;
    if (window.location.hash) {
        selectedTab = "." + window.location.hash.substring(1)
    }
    new Tabs(tabElements, selectedTab);   
}

document.addEventListener('DOMContentLoaded', function() {
    // setupForm()
    setupTabs()
})


export default {};
