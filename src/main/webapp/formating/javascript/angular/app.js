/*jshint undef: false, unused: false, indent: 2*/
/*global angular, i: false */

'use strict';
var app = angular.module('searchApp', ['multi-select-tree']);
app.service('getDepthFromPath', function () {
    this.myFunc = function (xpath) {
        var depth = xpath.match(/\//g);
        if (depth !== null) {
            depth = depth.length;
        } else {
            depth = 0;
        }
        depth = depth + 1;
        return depth;
    }
});
app.controller('searchAppCtrl', function ($scope, getDepthFromPath, $http) {

    var xpath = "";
    var label = "";
    var voc = "";
    var dataType = "";
    var xpaths = $("#xpaths").val();
    var labels = $("#labels").val();
    var dataTypes = $("#dataTypes").val();
    var vocs = $("#vocabularies").val();
    var thes = $("#thesaurus").val();

    var lang = $("#lang").val();

//    xpaths = xpaths.split("[")[1];
//    xpaths = xpaths.split("]")[0];
//    xpaths = xpaths.split(",");
//    labels = labels.split("[")[1];
//    labels = labels.split("]")[0];
//    labels = labels.split(",");
//    dataTypes = dataTypes.split("[")[1];
//    dataTypes = dataTypes.split("]")[0];
//    dataTypes = dataTypes.split(",");
//
//    vocs = vocs.split("[")[1];
//    vocs = vocs.split("]")[0];
//    vocs = vocs.split(",");

    var selectedInputs = $(".selectedInputs").val();
    var type = $(".category").val();
    if (!sessionStorage[type + ".xpaths"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        xpaths = xpaths.split("[")[1];
        xpaths = xpaths.split("]")[0];
        xpaths = xpaths.split(",");
        sessionStorage[type + ".xpaths"] = JSON.stringify(xpaths);
    } else {
        xpaths = JSON.parse(sessionStorage[type + ".xpaths"]);
    }

    if (!sessionStorage[type + ".labels"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        labels = labels.split("[")[1];
        labels = labels.split("]")[0];
        labels = labels.split(",");
        sessionStorage[type + ".labels"] = JSON.stringify(labels);

    } else {
        labels = JSON.parse(sessionStorage[type + ".labels"]);
    }

    if (!sessionStorage[type + ".dataTypes"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        dataTypes = dataTypes.split("[")[1];
        dataTypes = dataTypes.split("]")[0];
        dataTypes = dataTypes.split(",");
        sessionStorage[type + ".dataTypes"] = JSON.stringify(dataTypes);

    } else {
        dataTypes = JSON.parse(sessionStorage[type + ".dataTypes"]);
    }

    if (!sessionStorage[type + ".vocs"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        vocs = vocs.split("[")[1];
        vocs = vocs.split("]")[0];
        vocs = vocs.split(",");
        sessionStorage[type + ".vocs"] = JSON.stringify(vocs);
    } else {
        vocs = JSON.parse(sessionStorage[type + ".vocs"]);
    }

    if (!sessionStorage[type + ".thes"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        thes = thes.split("[")[1];
        thes = thes.split("]")[0];
        thes = thes.split(",");
        sessionStorage[type + ".thes"] = JSON.stringify(thes);
    } else {
        thes = JSON.parse(sessionStorage[type + ".thes"]);
    }
    $scope.items = [];
    $('.selectedInputs').each(function (i) {
        var value = $(".value:eq(" + i + ")").val();
        var selectedInput = $(this).val().trim();

        var objs = [];
        var showString = true;
        var showTime = false;
        var showMath = false;
        var showVoc = false;
        var showThes = false;

        var objsOutput = [];
//        if (selectedInputs !== undefined) {
//            selectedInputs = $(this).val().split("[")[1];
//            selectedInputs = selectedInputs.split("]")[0];
//            selectedInputs = selectedInputs.split(",");
//        }


        var previousDepth = 0;
        for (var i = 0; i < xpaths.length; i++) {
            var valueString = "";
            var valueTime = "";
            var valueVoc = "";
            var valueThes = "";

            var valueMath = "";

            showVoc = false;
            xpath = xpaths[i].trim();
            label = labels[i].trim();
            dataType = dataTypes[i].trim();
            voc = vocs[i].trim();

//            var termsUn = $(".terms:eq(" + i + ")").val();
//            var terms = [];
//            if (termsUn.length > 0) {
//                termsUn = termsUn.split("***");
////                alert(terms);
////                terms = terms.split("###")[0];
//                for (var k = 0; k < termsUn.length; k++) {
//                    if (termsUn[k] !== "" && termsUn[k] !== "-------------------") {
//                        terms.push(termsUn[k]);
//                    }
//                }
//                showVoc = true;
//                valueVoc = value;
//            }
            var terms = [];
            if (voc !== "") {
//                $http({
//                    method: "post",
//                    url: "GetTerms?vocName=" + voc + "&lang=" + lang,
//                    async: false
//                }).then(function mySucces(response) {
//                    alert("terms " + JSON.parse(JSON.stringify(response.terms)));
//
//                    terms = JSON.parse(response.terms);
//                    alert(terms);
//                }, function myError(response) {
//                    $scope.myWelcome = response.statusText;
//                    alert(response.statusText);
//                });



                showVoc = true;
                valueVoc = value;
            }


            var depth = getDepthFromPath.myFunc(xpath);
            if (dataType === "string") {
                showString = true;
                showTime = false;
                showThes = false;
                showMath = false;
                if (showVoc === false) {
                    valueString = value;
                }
            } else if (dataType === "time") {
                showString = false;
                showThes = false;
                showTime = true;
                showMath = false;
                valueTime = value;
            } else if (dataType === "math") {
                showString = false;
                showThes = false;
                showTime = false;
                showMath = true;
                valueMath = value;
            } else if (dataType === "thesaurus") {
                showString = false;
                showThes = true;
                showTime = false;
                showMath = false;
                valueThes = value;
            }




            if (depth === previousDepth) {

                var obj2 = {
                    id: xpath,
                    name: label,
                    dataType: dataType,
                    showString: showString,
                    showTime: showTime,
                    showThes: showThes,
                    valueString: valueString,
                    valueTime: valueTime,
                    valueVoc: valueVoc,
                    valueThes: valueThes,
                    showVoc: showVoc,
                    valueMath: valueMath,
                    showMath: showMath,
                    term: terms,
                    voc: voc,
                    children: []
                };
                var obj2Out = {
                    id: xpath,
                    name: label,
                    children: []
                };
                objs[depth - 2].children.push(obj2);
                objs[depth - 1] = obj2;
                objsOutput[depth - 2].children.push(obj2Out);
                objsOutput[depth - 1] = obj2Out;
                if (selectedInputs !== undefined) {
                    if (selectedInput.trim() === "/" + xpath) {
                        obj2.selected = true;
                    }
                }

                for (var k = 0; k < $('.selectedOutputs').length; k++) {
                    var outputValue = $(".selectedOutputs:eq(" + k + ")").val().trim();
                    if (outputValue === "/" + xpath) {
                        obj2Out.selected = true;
                    }
                }



            } else if (depth > previousDepth) {


                if (depth === 1) {
                    var obj = {
                        id: xpath,
                        name: label,
                        dataType: dataType,
                        showString: showString,
                        showTime: showTime,
                        showThes: showThes,
                        valueString: valueString,
                        valueTime: valueTime,
                        valueVoc: valueVoc,
                        valueThes: valueThes,
                        showVoc: showVoc,
                        valueMath: valueMath,
                        showMath: showMath,
                        term: terms,
                        voc: voc,
                        children: []
                    };
                    var objOut = {
                        id: xpath,
                        name: label,
                        children: []
                    };
                    objs[0] = obj;
                    objsOutput[0] = objOut;
                    if (selectedInputs !== undefined) {
                        if (selectedInput.trim() === "/" + xpath) {
                            obj.selected = true;
                        }
                    }

                    for (var k = 0; k < $('.selectedOutputs').length; k++) {
                        var outputValue = $(".selectedOutputs:eq(" + k + ")").val().trim();
                        if (outputValue === "/" + xpath) {
                            objOut.selected = true;
                        }
                    }
                } else {
                    var obj2 = {
                        id: xpath,
                        name: label,
                        dataType: dataType,
                        showString: showString,
                        showTime: showTime,
                        showThes: showThes,
                        valueString: valueString,
                        valueTime: valueTime,
                        valueVoc: valueVoc,
                        valueThes: valueThes,
                        showVoc: showVoc,
                        valueMath: valueMath,
                        showMath: showMath,
                        term: terms,
                        voc: voc,
                        children: []
                    };
                    var obj2Out = {
                        id: xpath,
                        name: label,
                        children: []
                    };
                    if (selectedInputs !== undefined) {
                        if (selectedInput.trim() === "/" + xpath) {
                            obj2.selected = true;
                        }
                    }
                    for (var k = 0; k < $('.selectedOutputs').length; k++) {
                        var outputValue = $(".selectedOutputs:eq(" + k + ")").val().trim();
                        if (outputValue === "/" + xpath) {
                            obj2Out.selected = true;
                        }
                    }

                    objs[depth - 2].children.push(obj2);
                    objs[depth - 1] = obj2;
                    objsOutput[depth - 2].children.push(obj2Out);
                    objsOutput[depth - 1] = obj2Out;
                }

            } else if (depth < previousDepth) {
                var obj2 = {
                    id: xpath,
                    name: label,
                    dataType: dataType,
                    showString: showString,
                    valueString: valueString,
                    valueTime: valueTime,
                    valueVoc: value,
                    valueThes: valueThes,
                    showTime: showTime,
                    showThes: showThes,
                    showVoc: showVoc,
                    valueMath: valueMath,
                    showMath: showMath,
                    term: terms,
                    voc: voc,
                    children: []
                };
                var obj2Out = {
                    id: xpath,
                    name: label,
                    children: []
                };
                if (selectedInputs !== undefined) {
                    if (selectedInput.trim() === "/" + xpath) {
                        obj2.selected = true;
                    }
                }

                for (var k = 0; k < $('.selectedOutputs').length; k++) {
                    var outputValue = $(".selectedOutputs:eq(" + k + ")").val().trim();
                    if (outputValue === "/" + xpath) {
                        obj2Out.selected = true;
                    }
                }
                objs.splice(objs.length - 1);
                objsOutput.splice(objsOutput.length - 1);

                objs[depth - 2].children.push(obj2);
                objs[depth - 1] = obj2;
                objsOutput[depth - 2].children.push(obj2Out);
                objsOutput[depth - 1] = obj2Out;
            }
            previousDepth = depth;
        }


        for (var k = objs.length - 1; k >= 1; k--) {
            objs.splice(k);
            objsOutput.splice(k);
        }

        $scope.item = [
            {data: angular.copy(objs)
            }
        ];
        $scope.output = angular.copy(objsOutput);
        if ($scope.items.length === 0) {
            $scope.items = $scope.item;
        } else {
            var currentList = $scope.items;
            var newList = currentList.concat($scope.item);
            $scope.items = newList;
        }

    });

    $scope.setDataType = function (item) {

        var dataType = item.dataType.trim();
        var isVocabulary = item.showVoc;
        // reference all the stuff you need first
        if (dataType.trim() === "string" && isVocabulary === false) {
            item.showString = true;
            item.showTime = false;
            item.showThes = false;
            item.showMath = false;
        } else if (dataType.trim() === "string" && isVocabulary === true) {
            item.showString = false;
            item.showTime = false;
            item.showThes = false;
            item.showMath = false;
        } else if (dataType === "time") {
            item.showString = false;
            item.showTime = true;
            item.showThes = false;
            item.showMath = false;
        } else if (dataType === "math") {
            item.showString = false;
            item.showThes = false;
            item.showTime = false;
            item.showMath = true;
        } else if (dataType === "thesaurus") {
            item.showString = false;
            item.showTime = false;
            item.showThes = true;
            item.showMath = false;
        }

    };



    function getAllChildNodesFromNode(node, childNodes) {
        for (var i = 0; i < node.children.length; i++) {

            childNodes.push(node.children[i]);
            // add the childNodes from the children if available
            getAllChildNodesFromNode(node.children[i], childNodes);
        }
        return childNodes;
    }

    $scope.addItem = function (item) {

        $('.input-filter').val('');
        angular.forEach(item.data, function (index) {
            var childNodes = getAllChildNodesFromNode(index, []);
            for (var i = 0, len = childNodes.length; i < len; i++) {
                childNodes[i].isFiltered = false;
                childNodes[i].filterKeyword = "";
            }
            index.isFiltered = false;
            index.filterKeyword = "";
        });
        $scope.items.push(angular.copy(item));

    };

    $scope.removeItem = function (item) {
        var index = $scope.items.indexOf(item);
        $scope.items.splice(index, 1);

    };
    $scope.showString = function (value) {

        if (value === undefined) {
            return true;
        } else {
            return value;
        }
    };
    $scope.showTime = function (value) {
        if (value === undefined) {
            return false;
        } else {
            return value;
        }
    };

    $scope.showMath = function (value) {
        if (value === undefined) {
            return false;
        } else {
            return value;
        }
    };

    $scope.showThes = function (value, item) {
        if (value === undefined) {
            return false;
        } else {
            if (value === true) {
                var xpath = item.id;
                if (item.term.length === 0) {
                    var request = $.ajax({
                        type: "post",
                        url: "GetTerms?xpath=" + xpath + "&lang=" + lang + "&action=getXpathTerms",
                        async: false
                    });
                    request.done(function (msg) {
                        item.term = JSON.parse(JSON.stringify(msg.terms));
                    });
                    request.fail(function (textStatus) {
                        alert("Request failed: " + textStatus);
                    });
                }
            }
            return value;
        }
    };

    $scope.showVoc = function (value, item) {

        if (value === undefined) {
            return false;
        } else {
            if (value === true) {
                var voc = item.voc;
                var xpath = item.id;
                if (item.term.length === 0) {
//                    var request = $.ajax({
//                        type: "post",
//                        url: "GetTerms?vocName=" + voc + "&lang=" + lang+"&action=getVocTerms",
//                        async: false
//                    });
                    var request = $.ajax({
                        type: "post",
                        url: "GetTerms?xpath=" + xpath + "&lang=" + lang + "&action=getXpathTerms",
                        async: false
                    });
                    request.done(function (msg) {
                        item.term = JSON.parse(JSON.stringify(msg.terms));
                    });
                    request.fail(function (textStatus) {
                        alert("Request failed: " + textStatus);
                    });
                }
            }
            return value;
        }
    };

    $scope.showConditionAnd = function (value1, value2) {
        if (value1 === undefined || value2 === undefined) {
            return false;
        } else {
            return (value1 && value2);
        }
    };

    $scope.showConditionOr = function (value1, value2) {
        if (value1 === undefined || value2 === undefined) {
            return false;
        } else {
            return (value1 || value2);
        }
    };

    $scope.vocSelected = function (term, value) {
        if (term === value) {
            return true;
        } else {
            return false;
        }
    };

    $scope.thesSelected = function (term, value) {
        if (term === value) {
            return true;
        } else {
            return false;
        }
    };
    $scope.clearAll = function (items) {
        $('.chzn-select').val('').trigger('liszt:updated');
        $('.searchString, .inputwidth').val('');


        angular.forEach($scope.output, function (index) {
            var childNodes = getAllChildNodesFromNode(index, []);
            for (var i = 0, len = childNodes.length; i < len; i++) {
                childNodes[i].selected = false;
            }
            index.selected = false;
        });

        angular.forEach($scope.items, function (item) {
            angular.forEach(item.data, function (index) {
                var childNodes = getAllChildNodesFromNode(index, []);
                for (var i = 0, len = childNodes.length; i < len; i++) {
                    childNodes[i].selected = false;
                }
                index.selected = false;
            });
        });

        $scope.items = angular.copy($scope.items);

        $scope.output = angular.copy($scope.output);

    };
});

