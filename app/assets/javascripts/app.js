var menu = angular.module('menu', ['ngAnimate', 'ui.bootstrap']);

menu.controller('menuController', function($scope, $http, $location){

  var noticeFadein = function() {
    console.log('test');
    $("#notice").hide();
    $("#notice").fadeIn(1000, function() {
      setTimeout(function() {
        $("#notice").fadeOut(500);
      }, 3000);
    });
  }

  var user_id = (/users\/(\d+)/.exec($location.absUrl())[1]);
  $scope.user_id = user_id;
  var game_character_id = (/game_characters\/(\d+)/.exec($location.absUrl())[1]);
  $scope.game_character_id = game_character_id;
  $scope.notice = null;
  var inventory_url = "http://localhost:3000/users/" + user_id + "/game_characters.json";
  $http.get(inventory_url).success(function(response) {
    $scope.items = response.character_items;
    $scope.character_strength = response.character_strength;
    $scope.character_constitution = response.character_constitution;
    $scope.gold = response.gold;
  });
  $scope.itemDetail = false;

  var shop_url = "http://localhost:3000/users/" + user_id + "/items.json";
  $http.get(shop_url).success(function(response){
    $scope.shopItems = response;
  });

  var enemy_url = "http://localhost:3000/users/" + user_id + "/game_characters/" + game_character_id +"/enemies.json";
  $http.get(enemy_url).success(function(response) {
    $scope.enemies = response.enemies;
    $scope.game_character = response.game_character
  });

  var player_challenge_url = "http://localhost:3000/users/" + user_id + "/game_characters/" + game_character_id +"/player_challenges.json";
  $http.get(player_challenge_url).success(function(response) {
    $scope.players = response.players;
    $scope.game_character = response.game_character
  });

  $scope.buy = function(item_id) {
    $http({
      method: "POST",
      url: "http://localhost:3000/users/" + user_id + "/items/" + item_id + "/game_character_items",
      data: {game_character: game_character_id, item: item_id}
    }).then(function() {
      var url = "http://localhost:3000/users/" + user_id + "/game_characters.json";
      $http.get(url).success(function(response) {
        $scope.items = response.character_items;
        $scope.character_strength = response.character_strength;
        $scope.character_constitution = response.character_constitution;
        $scope.gold = response.gold;
        $scope.notice = "Purchased!"
        noticeFadein();
        $scope.chartHideStatus = true;
        $scope.shopHideStatus = true;
        $scope.enemyHideStatus = true;
        $scope.inventoryHideStatus = $scope.inventoryHideStatus === false;
        })
      }).catch(function() {
        $scope.notice = "You can't do that! Either your bag is full or you don't have enough gold!";
        noticeFadein();
    });
  };

  $scope.sell = function(item_id) {
    $http({
      method: "DELETE",
      url: "http://localhost:3000/users/" + user_id + "/game_characters/" + game_character_id + "/game_character_items/" + item_id,
    }).then(function() {
      var url = "http://localhost:3000/users/" + user_id + "/game_characters.json";
      $http.get(url).success(function(response) {
        $scope.items = response.character_items;
        $scope.character_strength = response.character_strength;
        $scope.character_constitution = response.character_constitution;
        $scope.gold = response.gold;
        $scope.notice = "Sold!";
        noticeFadein();
      });
    });
  }



  $scope.inventoryHideStatus = true;
  $scope.chartHideStatus = true;
  $scope.shopHideStatus = true;
  $scope.enemyHideStatus = true;
  $scope.playerChallengeHideStatus = true;
  $scope.achievementHideStatus = true;
  $scope.toggleInventory = function() {
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.playerChallengeHideStatus = true;
    $scope.achievementHideStatus = true;
    $scope.inventoryHideStatus = $scope.inventoryHideStatus === false ? true : false;
  };
  $scope.toggleChart = function() {
    $scope.inventoryHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.playerChallengeHideStatus = true;
    $scope.achievementHideStatus = true;
    $scope.chartHideStatus = $scope.chartHideStatus === false ? true : false;
  };
  $scope.toggleShop = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.playerChallengeHideStatus = true;
    $scope.achievementHideStatus = true;
    $scope.shopHideStatus = $scope.shopHideStatus === false ? true : false;
  };
  $scope.toggleEnemy = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.playerChallengeHideStatus = true;
    $scope.achievementHideStatus = true;
    $scope.enemyHideStatus = $scope.enemyHideStatus === false ? true : false;
  };
  $scope.toggleChallenge = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.achievementHideStatus = true;
    $scope.playerChallengeHideStatus = $scope.playerChallengeHideStatus === false ? true : false;
  };
  $scope.toggleAchievement = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.playerChallengeHideStatus = true;
    $scope.achievementHideStatus = $scope.achievementHideStatus === false ? true : false;
  };
});

menu.controller('descriptionController', function($scope){
  $scope.expDescription = false;
  $scope.goldDescription = false;
  $scope.energyDescription = false;
  $scope.strengthDescription = false;
  $scope.constitutionDescription = false;
});
