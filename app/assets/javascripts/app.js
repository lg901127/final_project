var menu = angular.module('menu', ['ngAnimate']);

menu.controller('itemController', function($scope, $http, $location){
  var user_id = (/users\/(\d+)/.exec($location.absUrl())[1]);
  var game_character_id = (/game_characters\/(\d+)/.exec($location.absUrl())[1]);
  var url = "http://localhost:3000/users/" + user_id + "/game_characters/" + game_character_id +".json";
  $http.get(url).success(function(response) {
    $scope.items = response;
  });
  $scope.itemDetail = false;
});

menu.controller('shopController', function($scope, $http, $location){
  var user_id = (/users\/(\d+)/.exec($location.absUrl())[1]);
  var game_character_id = (/game_characters\/(\d+)/.exec($location.absUrl())[1]);
  var url = "http://localhost:3000/users/" + user_id + "/items.json";
  $http.get(url).success(function(response){
    $scope.shopItems = response;
  });
  $scope.itemDetail = false;
});

menu.controller('enemyController', function($scope, $http, $location){
  var user_id = (/users\/(\d+)/.exec($location.absUrl())[1]);
  var game_character_id = (/game_characters\/(\d+)/.exec($location.absUrl())[1]);
  var url = "http://localhost:3000/users/" + user_id + "/game_characters/" + game_character_id +"/enemies.json";
  $http.get(url).success(function(response) {
    $scope.enemies = response.enemies;
    $scope.game_character = response.game_character
  });
});

menu.controller('toggleController', function($scope){
  $scope.inventoryHideStatus = true;
  $scope.chartHideStatus = true;
  $scope.shopHideStatus = true;
  $scope.enemyHideStatus = true;
  $scope.toggleInventory = function() {
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.inventoryHideStatus = $scope.inventoryHideStatus === false ? true: false;
  };
  $scope.toggleChart = function() {
    $scope.inventoryHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.chartHideStatus = $scope.chartHideStatus === false ? true: false;
  };
  $scope.toggleShop = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.enemyHideStatus = true;
    $scope.shopHideStatus = $scope.shopHideStatus === false ? true: false;
  };
  $scope.toggleEnemy = function() {
    $scope.inventoryHideStatus = true;
    $scope.chartHideStatus = true;
    $scope.shopHideStatus = true;
    $scope.enemyHideStatus = $scope.enemyHideStatus === false ? true: false;
  };
});

menu.controller('descriptionController', function($scope){
  $scope.expDescription = false;
  $scope.goldDescription = false;
  $scope.energyDescription = false;
  $scope.strengthDescription = false;
  $scope.constitutionDescription = false;
});
