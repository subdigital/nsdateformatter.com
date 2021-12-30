import { show, hide } from './util.js';

class Tabs {
    constructor(tabs, selectedTab = null) {
        this.allTabs = tabs;
        if (selectedTab) {
            this.selectedTab = selectedTab;
        } else {
            this.selectedTab = tabs[0].dataset.target;
        }
        this.tabSelect = document.querySelector("#tabs-select");

        let parentNav = tabs[0].closest("nav");
        this.tabOnClasses = parentNav.dataset.tabOn;
        this.tabOffClasses = parentNav.dataset.tabOff;

        this.allTabs.forEach((tab) => {
            tab.addEventListener('click', this.tabClick.bind(this));
            (tab.dataset.target == this.selectedTab) ?
                this.tabOn(tab) : this.tabOff(tab);
        });


        this.tabSelect.addEventListener("change", () => {
            let opt = this.tabSelect.selectedOptions[0];
            if (opt) {
                window.location.hash = opt.dataset.target.substring(1);
                this.setTab(opt.dataset.target);
            }
        });
    }

    tabOn(tab) {
        this.tabOffClasses.split(/\s+/).forEach((c) => tab.classList.remove(c));
        this.tabOnClasses.split(/\s+/).forEach((c) => tab.classList.add(c));
        let target = document.querySelector(tab.dataset.target);
        if (target) {
            show(target);
        } else {
            console.warn("tab target missing: ", tab.dataset.target);
        }

        // select the current one in the mobile nav dropdown
        let opt = this.tabSelect.querySelector(`option[data-target='${tab.dataset.target}']`);
        if (opt) {
            opt.selected = true;
        }

    }

    tabOff(tab) {
        this.tabOnClasses.split(/\s+/).forEach((c) => tab.classList.remove(c))
        this.tabOffClasses.split(/\s+/).forEach((c) => tab.classList.add(c))
        let target = document.querySelector(tab.dataset.target)
        if (target) {
            hide(target)
        } else {
            console.warn("tab target missing: ", tab.dataset.target)
        }
    }

    setTab(target) {
        this.allTabs.forEach((tab) => {
            if (tab.dataset.target == target) {
                this.tabOn(tab)
            } else {
                this.tabOff(tab)
            }
        });
    }

    tabClick(event) {
        let tab = event.target;
        this.setTab(tab.dataset.target);
    }
}

export default Tabs;
