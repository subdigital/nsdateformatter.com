import "./css/main.css";

import Formatter from "./js/formatter.js";
import Tabs from "./js/tabs.js";

function setupTabs() {
    const tabElements = document.querySelectorAll("nav a[data-target]");
    let selectedTab = null;
    if (window.location.hash) {
        selectedTab = `.${window.location.hash.substring(1)}`;
    }

    new Tabs(tabElements, selectedTab);
}

function setupFormatter() {
    new Formatter();
}

document.addEventListener(
    "DOMContentLoaded",
    () => {
        setupFormatter();
        setupTabs();
    }
);

export default {};

