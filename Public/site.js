let allTabs = []

function hide(el) {
  if (el) {
    el.classList.add("hidden")
  }
}

function show(el) {
  if (el) {
    el.classList.remove("hidden")
  }
}

function tabOn(tab) {
  let tabOnClasses = tab.closest("nav").dataset.tabOn;
  let tabOffClasses = tab.closest("nav").dataset.tabOff;
  tabOffClasses.split(/\s+/).forEach((c) => tab.classList.remove(c));
  tabOnClasses.split(/\s+/).forEach((c) => tab.classList.add(c));
  let target = document.querySelector(tab.dataset.target);
  if (target) {
    show(target);
  } else {
    console.warn("tab target missing: ", tab.dataset.target);
  }
}

function tabOff(tab) {
  let tabOnClasses = tab.closest("nav").dataset.tabOn;
  let tabOffClasses = tab.closest("nav").dataset.tabOff;
  tabOnClasses.split(/\s+/).forEach((c) => tab.classList.remove(c));
  tabOffClasses.split(/\s+/).forEach((c) => tab.classList.add(c));
  let target = document.querySelector(tab.dataset.target);
  if (target) {
    hide(target);
  } else {
    console.warn("tab target missing: ", tab.dataset.target);
  }
}

function tabClick(event) {
  event.preventDefault();
  allTabs.forEach( (tab) => {
    if (tab == this) {
      tabOn(tab);
    } else {
      tabOff(tab);
    }
  });
}

document.addEventListener('DOMContentLoaded', function() {
  allTabs = document.querySelectorAll("nav a[data-target]");
  allTabs.forEach((tab) => {
    tab.addEventListener("click", tabClick);
    tabOff(tab);
  });
  tabOn(allTabs[0]);
});

