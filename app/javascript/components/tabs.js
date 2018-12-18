// tabs.js
const initTabs = () => {
  const buttons = document.querySelectorAll(".sidebar-btn_js");
  // tabs or sections
  const sprintTab = document.getElementById("sprint-stats_js");
  const teamTab = document.getElementById("team-stats_js");
  // buttons on the sidebar
  const sprintTabButton = document.getElementById("sprint-stats-btn_js");
  const teamTabButton = document.getElementById("team-stats-btn_js");

  // members
  const membersTab = document.getElementById("members-stats_js");
  const memberTab = document.getElementById("member-stats_js");

  // for the member cards logic
  const memberCards = document.querySelectorAll(".members-cards_js")

  teamTab.classList.add("hidden");
  sprintTabButton.classList.add("tab-active_js");

  buttons.forEach((button) => {
    button.addEventListener("click", (event) => {
      const buttonTarget = event.target.parentElement;
      if (buttonTarget.id === "sprint-stats-btn_js") {
        sprintTab.classList.remove("hidden");
        teamTab.classList.add("hidden");
        sprintTabButton.classList.add("tab-active_js");
        teamTabButton.classList.remove("tab-active_js");
      } else if (buttonTarget.id === "team-stats-btn_js") {
        sprintTab.classList.add("hidden");
        teamTab.classList.remove("hidden");
        sprintTabButton.classList.remove("tab-active_js");
        teamTabButton.classList.add("tab-active_js");
        // hide all the member sections
        membersTab.classList.remove("hidden");
        memberTab.classList.add("hidden");
        // remove active tag on all member cards
        memberCards.forEach((memberCard) => {
          memberCard.classList.remove("member-card-active_js");
        })
      };
    });
  });

  memberCards.forEach((memberCard) => {
    memberCard.addEventListener("click", (event) => {
      const memberTarget = event.target;
      // TODO for whichever target, find corresponding member section
      const memberCardSelected = memberTarget.parentElement;
      const w = memberTarget.id.split("-");
      const memberSectionSelected = document.getElementById(`member-section_js-${w[2]}`);

      membersTab.classList.add("hidden");
      memberTab.classList.remove("hidden");

      memberCards.forEach((memberCard) => {
        console.log(memberCard);
        const z = memberCard.lastElementChild.id.split("-");
        const memberSection = document.getElementById(`member-section_js-${z[2]}`);
        if (memberCardSelected === memberCard) {
          memberCardSelected.classList.add("member-card-active_js");
          memberSectionSelected.classList.remove("hidden");
        } else {
          memberCard.classList.remove("member-card-active_js");
          memberSection.classList.add("hidden");
        };
      });
    });
  });
};

export { initTabs };
