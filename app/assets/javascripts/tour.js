var tour = {
  id: "hello-hopscotch",
  steps: [
    {
      title: "Level",
      content: "This is your character's level, it is affected by the amount of your attributes.",
      target: "menu-level",
      placement: "top"
    },
    {
      title: "Experience",
      content: "This is your character's experience, it is calculated by your calorie consumption. You can use it to power up your character",
      target: "menu-exp",
      placement: "top"
    },
    {
      title: "Gold",
      content: "This is the currency of game, it is calculated by the steps you take. The longer you walk, the more money you earn. You can use it to purchase items to power up your character",
      target: "menu-gold",
      placement: "top"
    },
    {
      title: "Energy",
      content: "This is your character's energy, it is required when you complete quest or challenge other players. It is recovered when you are taking a rest.",
      target: "menu-energy",
      placement: "top"
    },
    {
      title: "Strength",
      content: "It affects the damage you can make.",
      target: "menu-strength",
      placement: "top"
    },
    {
      title: "Constitution",
      content: "It affects your HP.",
      target: "menu-constitution",
      placement: "left"
    },
    {
      title: "Inventory",
      content: "A six-slot backpack",
      target: "inventory-btn",
      placement: "bottom"
    },
    {
      title: "Charts",
      content: "Visualize your fitness data by differenct charts",
      target: "chart-btn",
      placement: "bottom"
    },
    {
      title: "Shop",
      content: "Spend your gold to buy gears that boost you up.",
      target: "shop-btn",
      placement: "bottom"
    },
    {
      title: "Quest",
      content: "Finish quests to earn extra exp and gold.",
      target: "quest-btn",
      placement: "bottom"
    },
    {
      title: "Challenge Other Players",
      content: "Challenge other players.",
      target: "challenge-btn",
      placement: "bottom"
    }
  ]
};
$(document).ready(function() {
  $('#start-tour').click(function() {
    hopscotch.startTour(tour);
  });
});
