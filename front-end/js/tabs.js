import {show, hide} from './util.js';

class Tabs {
    constructor(tabs, selectedTab = null) {
        this.allTabs = tabs;
        if (selectedTab) {
            this.selectedTab = selectedTab;
        } else {
            this.selectedTab = tabs[0].dataset.target;
        }

        let parentNav = tabs[0].closest("nav");
        this.tabOnClasses = parentNav.dataset.tabOn;
        this.tabOffClasses = parentNav.dataset.tabOff;

        this.allTabs.forEach((tab) => {
            tab.addEventListener('click', this.tabClick.bind(this));
            (tab.dataset.target == this.selectedTab) ?
                this.tabOn(tab) : this.tabOff(tab);
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

    tabClick(event) {
        this.allTabs.forEach( (tab) => {
            if (tab == event.target) {
                this.tabOn(tab)
            } else {
                this.tabOff(tab)
            }
        });
    }
}

export default Tabs;
