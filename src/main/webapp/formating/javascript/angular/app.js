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
    var link = "";

    var dataType = "";
    var xpaths = $("#xpaths").val();
    var labels = $("#labels").val();
    var dataTypes = $("#dataTypes").val();
    var vocs = $("#vocabularies").val();
    var thes = $("#thesaurus").val();
    var links = $("#links").val();

    var lang = $("#lang").val();


    var selectedInputs = $(".selectedInputs").val();
    var type = $(".category").val();
    console.log(type)
    if (!sessionStorage[type + lang + ".xpaths"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        xpaths = xpaths.split("[")[1];
        xpaths = xpaths.split("]")[0];
        xpaths = xpaths.split(",");
        sessionStorage[type + lang+ ".xpaths"] = JSON.stringify(xpaths);
    } else {
        xpaths = JSON.parse(sessionStorage[type + lang+ ".xpaths"]);
    }

    if (!sessionStorage[type + lang + ".labels"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        labels = labels.split("[")[1];
        labels = labels.split("]")[0];
        labels = labels.split(",");
        sessionStorage[type + lang + ".labels"] = JSON.stringify(labels);

    } else {
        labels = JSON.parse(sessionStorage[type + lang + ".labels"]);
    }

    if (!sessionStorage[type + lang + ".dataTypes"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
        dataTypes = dataTypes.split("[")[1];
        dataTypes = dataTypes.split("]")[0];
        dataTypes = dataTypes.split(",");
        sessionStorage[type + lang + ".dataTypes"] = JSON.stringify(dataTypes);

    } else {
        dataTypes = JSON.parse(sessionStorage[type + lang + ".dataTypes"]);
    }
    if (vocs !== undefined) {

        if (!sessionStorage[type + lang +  ".vocs"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
            vocs = vocs.split("[")[1];
            vocs = vocs.split("]")[0];
            vocs = vocs.split(",");
            sessionStorage[type + lang +  ".vocs"] = JSON.stringify(vocs);
        } else {
            vocs = JSON.parse(sessionStorage[type + lang +  ".vocs"]);
        }
    }
    if (thes !== undefined) {

        if (!sessionStorage[type + lang + ".thes"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
            thes = thes.split("[")[1];
            thes = thes.split("]")[0];
            thes = thes.split(",");
            sessionStorage[type + lang + ".thes"] = JSON.stringify(thes);
        } else {
            thes = JSON.parse(sessionStorage[type + lang + ".thes"]);
        }
    }
    if (links !== undefined) {

        if (!sessionStorage[type + lang + ".links"]) { //If first time or xpaths empty (length=2 []), ask server for info (all 4 tables)
            links = links.split("[")[1];
            links = links.split("]")[0];
            links = links.split(",");
            sessionStorage[type + lang + ".links"] = JSON.stringify(links);
        } else {
            links = JSON.parse(sessionStorage[type + lang + ".links"]);
        }
    }
    $scope.items = [];
    $scope.refByItems = [];
    $scope.previousSelrefByItems = [];
    $scope.selValue = [];
    console.log("" +$('.selectedInputs'));
    $('.selectedInputs').each(function (i) {
        var value = $(".value:eq(" + i + ")").val();
        var selectedInput = $(this).val().trim();
        if (selectedInput !== "refBy_/") {
            console.log(selectedInput);
            if (selectedInput !== '[]') {
                type = selectedInput.split("/")[1];
            }

            xpaths = sessionStorage[type + lang+ ".xpaths"];
            if (xpaths === undefined || xpaths === '[""]') {
                var request = $.ajax({
                    type: "post",
                    url: "GetTerms?category=" + type + "&lang=" + lang + "&action=getListOfTags",
                    async: false
                });
                request.done(function (msg) {
                    console.log(msg)
                    sessionStorage[type + lang+ ".xpaths"] = JSON.stringify(msg.xpaths);
                    sessionStorage[type + lang + ".labels"] = JSON.stringify(msg.labels);
                    sessionStorage[type + lang + ".dataTypes"] = JSON.stringify(msg.dataTypes);
                    sessionStorage[type + lang +  ".vocs"] = JSON.stringify(msg.vocTags);
                    sessionStorage[type + lang + ".thes"] = JSON.stringify(msg.thesTags);
                    sessionStorage[type + lang + ".links"] = JSON.stringify(msg.linksTags);
                    if (selectedInput.indexOf("refBy_") >= 0) {
                        var obj = initTrees(value, selectedInput.split("refBy_")[1], msg.xpaths, msg.labels, msg.dataTypes, msg.vocTags, msg.thesTags, msg.linksTags);
                    } else {
                        var obj = initTrees(value, selectedInput, msg.xpaths, msg.labels, msg.dataTypes, msg.vocTags, msg.thesTags, msg.linksTags);

                    }
                    var objsOutput = obj[1];
                    for (var k = objsOutput.length - 1; k >= 1; k--) {
                        objsOutput.splice(k);
                    }
                    $scope.output = angular.copy(objsOutput);
                    if (selectedInput.indexOf("refBy_") > 0) {
                        setInputObjRefTree(obj, 0, 'setRefEntity');
                        if ($('#refByChosen option[value=' + type + ']').val() !== undefined) {
                            $('#refByChosen option[value=' + type + ']').prop('selected', true);
                            $('#refByChosen').trigger('liszt:updated');
                            $('#collapsesearchAtRefsBy').collapse();
                            $scope.selValue.push(type);
                            $scope.previousSelrefByItems.push(type);
                        }
                    } else {
                        setInputObj(obj, 0, 'selectEntity');
                    }
                });
                request.fail(function (textStatus) {
                    alert("Request failed: " + textStatus);
                });
            } else {
                xpaths = JSON.parse(sessionStorage[type + lang+ ".xpaths"]);
                labels = JSON.parse(sessionStorage[type + lang + ".labels"]);
                dataTypes = JSON.parse(sessionStorage[type + lang + ".dataTypes"]);
                vocs = JSON.parse(sessionStorage[type + lang +  ".vocs"]);
                thes = JSON.parse(sessionStorage[type + lang + ".thes"]);
                links = JSON.parse(sessionStorage[type + lang + ".links"]);
                if (selectedInput.indexOf("refBy_") >= 0) {
                    var obj = initTrees(value, selectedInput.split("refBy_")[1], xpaths, labels, dataTypes, vocs, thes, links);
                } else {
                    var obj = initTrees(value, selectedInput, xpaths, labels, dataTypes, vocs, thes, links);
                }
                var objsOutput = obj[1];
                for (var k = objsOutput.length - 1; k >= 1; k--) {
                    objsOutput.splice(k);
                }
                $scope.output = angular.copy(objsOutput);

                if (selectedInput.indexOf("refBy_") >= 0) {
                    setInputObjRefTree(obj, 0, 'setRefEntity');
                    console.log(type);

                    if ($('#refByChosen option[value=' + type + ']').val() !== undefined) {
                        $('#refByChosen option[value=' + type + ']').prop('selected', true);
                        $('#refByChosen').trigger('liszt:updated');
                        $('#collapsesearchAtRefsBy').collapse();
                        $scope.selValue.push(type);
                        $scope.previousSelrefByItems.push(type);
                    }
                } else {
                    setInputObj(obj, 0, 'selectEntity');
                }
            }
        }
    });

    $scope.setDataType = function (item, index, usedTree) {
        var dataType = item.dataType.trim();
        var isVocabulary = item.showVoc;
        var isLink = item.showLink;
        // reference all the stuff you need first
        if (dataType.trim() === "string" && isVocabulary === false && isLink == false) {
            item.showString = true;
            item.showTime = false;
            item.showThes = false;
            item.showMath = false;
            item.valueString = "";
        } else if (dataType.trim() === "string" && (isVocabulary === true || isLink === true)) {
            item.showString = false;
            item.showTime = false;
            item.showThes = false;
            item.showMath = false;
            item.valueVoc = "";
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
            item.valueThes = "";
        }

        if (item !== undefined) {
            removeExternalEntities(index, usedTree);
        }
    };

    function initTrees(value, selectedInput, xpaths, labels, dataTypes, vocs, thes, links) {
        var objs = [];
        var showString = true;
        var showTime = false;
        var showMath = false;
        var showVoc = false;
        var showThes = false;
        var showLink = false;

        var objsOutput = [];

        var previousDepth = 0;

        for (var i = 0; i < xpaths.length; i++) {
            var valueString = "";
            var valueTime = "";
            var valueVoc = "";
            var valueThes = "";
            var valueLink = "";

            var valueMath = "";

            showVoc = false;
            showLink = false;

            xpath = xpaths[i].trim();
            label = labels[i].trim();
            dataType = dataTypes[i].trim();
            voc = vocs[i].trim();
            link = links[i].trim();

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
            if (link === "true") {
                showLink = true;
                showString = false;
                valueLink = value;
            } else {
                showLink = false;
            }
            var depth = getDepthFromPath.myFunc(xpath);
            if (dataType === "string") {
                if (showLink !== true) {
                    showString = true;
                } else {
                    showString = false;


                }
                showTime = false;
                showThes = false;
                showMath = false;
                if (showVoc === false && showLink === false) {
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
                    valueLink: valueLink,
                    valueThes: valueThes,
                    showVoc: showVoc,
                    showLink: showLink,
                    valueMath: valueMath,
                    showMath: showMath,
                    term: terms,
                    voc: voc,
                    link: link,
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
                        valueLink: valueLink,
                        valueThes: valueThes,
                        showVoc: showVoc,
                        showLink: showLink,
                        valueMath: valueMath,
                        showMath: showMath,
                        term: terms,
                        voc: voc,
                        link: link,
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
                        valueLink: valueLink,
                        valueThes: valueThes,
                        showVoc: showVoc,
                        showLink: showLink,
                        valueMath: valueMath,
                        showMath: showMath,
                        term: terms,
                        voc: voc,
                        link: link,
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
                    valueLink: valueLink,
                    valueThes: valueThes,
                    showTime: showTime,
                    showThes: showThes,
                    showVoc: showVoc,
                    showLink: showLink,
                    valueMath: valueMath,
                    showMath: showMath,
                    term: terms,
                    voc: voc,
                    link: link,
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
        return  [
            objs,
            objsOutput
        ];
        ;
    }

    function getAllChildNodesFromNode(node, childNodes) {
        for (var i = 0; i < node.children.length; i++) {

            childNodes.push(node.children[i]);
            // add the childNodes from the children if available
            getAllChildNodesFromNode(node.children[i], childNodes);
        }
        return childNodes;
    }

    function removeExternalEntities(index, usedTree) {
        if (usedTree === 'currentEntity') {
            var currentCategory = $scope.items[index].data[0].id;
            var entityCategory = $scope.items[0].data[0].id;
            var stopLoop = false;
            var itemsToRemove = [];
//            var targetValue = $("#target").val();
//            var lastO = targetValue.lastIndexOf("/");
//            var collection = targetValue.substring(0, lastO);
            for (var i = (index + 1); i < $scope.items.length; i++) {
                if (!stopLoop) {
                    if ($scope.items[i].data[0].id !== currentCategory && $scope.items[i].data[0].id !== entityCategory) {
                        //             $('input[value="' + collection + '/' + $scope.items[i].data[0].id + '"]').remove();
                        itemsToRemove.push(i);
                    } else {
                        stopLoop = true;
                    }
                }

            }

            $scope.items.splice((index + 1), itemsToRemove.length);
        } else {
            if ($scope.refByItems.length !== 0) {
                console.log(index);
                console.log($scope.refByItems);
                var currentCategory = $scope.refByItems[index].data[0].id;
                var entityCategory = $scope.selValue;
                var stopLoop = false;
                var itemsToRemove = [];
//                var targetValue = $("#target").val();
//                var lastO = targetValue.lastIndexOf("/");
//                var collection = targetValue.substring(0, lastO);
                for (var i = (index + 1); i < $scope.refByItems.length; i++) {
                    if (!stopLoop) {
                        if ($scope.refByItems[i].data[0].id !== currentCategory && jQuery.inArray($scope.refByItems[i].data[0].id, entityCategory) === -1) {

                            //  $('input[value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"]').remove();
                            itemsToRemove.push(i);
                        } else {
                            stopLoop = true;
                        }
                    }

                }

                $scope.refByItems.splice((index + 1), itemsToRemove.length);
            }
        }
    }

    function setInputObj(obj, index, type) {
        var objs = obj[0];

        for (var k = objs.length - 1; k >= 1; k--) {
            objs.splice(k);
        }
        $scope.item = [
            {data: angular.copy(objs)
            }
        ];
        if ($scope.items.length === 0) {
            $scope.items = $scope.item;
        } else {
            if (type === 'selectEntity') {
                var currentList = $scope.items;
                var newList = currentList.concat($scope.item);
                $scope.items = newList;
            } else {
                var currentList = $scope.items;
                var newList = [];
                for (var i = 0; i <= currentList.length; i++) {
                    if (i === (index + 1)) {
                        newList = newList.concat($scope.item);
                    }
                    if (currentList[i] !== undefined) {
                        newList = newList.concat(currentList[i]);
                    }

                }
                $scope.items = newList;
            }
        }

    }

    function setInputObjRefTree(obj, index, type) {
        var objs = obj[0];

        for (var k = objs.length - 1; k >= 1; k--) {
            objs.splice(k);
        }
        $scope.item = [
            {data: angular.copy(objs)
            }
        ];

        if (type === 'setRefEntity') {

            if ($scope.refByItems.length === 0) {
                $scope.refByItems = $scope.item;
            } else {
                var currentList = $scope.refByItems;
                var newList = currentList.concat($scope.item);
                $scope.refByItems = newList;
            }
        } else {
            var currentList = $scope.refByItems;
            var newList = [];
            for (var i = 0; i <= currentList.length; i++) {
                if (i === (index + 1)) {
                    newList = newList.concat($scope.item);
                }
                if (currentList[i] !== undefined) {
                    newList = newList.concat(currentList[i]);
                }

            }
            $scope.refByItems = newList;
        }
    }

    $scope.addItem = function (item, usedTree) {
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
        if (usedTree === 'currentEntity') {
            $scope.items.push(angular.copy(item));
        }
        else {
            $scope.refByItems.push(angular.copy(item));
        }

    };

    $scope.selectEntity = function (allSel) {
        var type = "";
        var index = allSel.length - 1;
        console.log("new selection");
        console.log(allSel);
        console.log("previous selection");
        console.log($scope.previousSelrefByItems);
        if (allSel.length < $scope.previousSelrefByItems.length) { //evgale ontothta
            var removedEntity = "";
            var itemsToRemove = [];
            for (var i = 0; i < $scope.previousSelrefByItems.length; i++) {

                if (jQuery.inArray($scope.previousSelrefByItems[i], $scope.selValue) === -1) {
                    removedEntity = $scope.previousSelrefByItems[i];
                }
            }
            console.log(removedEntity);
//            var targetValue = $("#target").val();
//            var lastO = targetValue.lastIndexOf("/");
//            var collection = targetValue.substring(0, lastO);
            for (var i = 0; i < $scope.refByItems.length; i++) {
                console.log("i--> " + i);
                console.log("in row--> " + $scope.refByItems[i].data[0].id);
                if ($scope.refByItems[i].data[0].id === removedEntity) {
                    console.log("delete " + i);
                    //    $('input[value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"]').remove();
                    itemsToRemove.push(i);
                    var index = i + 1;
                    for (var j = index; j < $scope.refByItems.length; j++) {
                        if (jQuery.inArray($scope.refByItems[j].data[0].id, allSel) === -1) {
                            itemsToRemove.push(j);
                            i = j;
                            //  console.log($('input[value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"]'));
                            //$('input[value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"]').remove();
                        } else {
                            j = $scope.refByItems.length;
                        }
                    }
                }


            }
            var temp = [].concat($scope.refByItems);
            console.log("item. to remove " + itemsToRemove.length);
            for (var i = 0; i < itemsToRemove.length; i++) {
                var postToDelete = (itemsToRemove[i] - i);
                temp.splice(postToDelete, 1);
            }
            $scope.refByItems = [].concat(temp);
            var pos = $scope.previousSelrefByItems.indexOf(removedEntity);

            $scope.previousSelrefByItems.splice(pos, 1);

        } else {
            if ($scope.previousSelrefByItems.length === 0) {
                $scope.previousSelrefByItems.push(allSel[0]);
                type = allSel[0];
            } else {
                for (var i = 0; i < allSel.length; i++) {
                    console.log("len -->" + allSel.length);

                    console.log("i-->  " + i);
                    console.log("---> " + allSel[i]);
                    if (jQuery.inArray(allSel[i], $scope.previousSelrefByItems) === -1) {
                        console.log("in");
                        console.log(allSel[i]);
                        type = allSel[i];
                    }
                }
                $scope.previousSelrefByItems.push(type);
            }
            console.log(type);

            if (type !== undefined) {
                $('.input-filter').val('');
//                var targetValue = $("#target").val();
//                var lastO = targetValue.lastIndexOf("/");
//                var collection = targetValue.substring(0, lastO);
//                $('<input type="hidden" name="target" value="' + collection + '/' + type + '"/>').insertAfter($("#target"));
                if (!sessionStorage[type + lang+ ".xpaths"]) {
                    var request = $.ajax({
                        type: "post",
                        url: "GetTerms?category=" + type + "&lang=" + lang + "&action=getListOfTags",
                        async: false
                    });
                    request.done(function (msg) {
                        sessionStorage[type + lang+ ".xpaths"] = JSON.stringify(msg.xpaths);
                        sessionStorage[type + lang + ".labels"] = JSON.stringify(msg.labels);
                        sessionStorage[type + lang + ".dataTypes"] = JSON.stringify(msg.dataTypes);
                        sessionStorage[type + lang +  ".vocs"] = JSON.stringify(msg.vocTags);
                        sessionStorage[type + lang + ".thes"] = JSON.stringify(msg.thesTags);
                        sessionStorage[type + lang + ".links"] = JSON.stringify(msg.linksTags);

                        var obj = initTrees("", "", msg.xpaths, msg.labels, msg.dataTypes, msg.vocTags, msg.thesTags, msg.linksTags);

                        setInputObjRefTree(obj, index, 'setRefEntity');

                    });
                    request.fail(function (textStatus) {
                        alert("Request failed: " + textStatus);
                    });
                } else {
                    xpaths = JSON.parse(sessionStorage[type + lang+ ".xpaths"]);
                    labels = JSON.parse(sessionStorage[type + lang + ".labels"]);
                    dataTypes = JSON.parse(sessionStorage[type + lang + ".dataTypes"]);
                    vocs = JSON.parse(sessionStorage[type + lang +  ".vocs"]);
                    thes = JSON.parse(sessionStorage[type + lang + ".thes"]);
                    links = JSON.parse(sessionStorage[type + lang + ".links"]);
                    var obj = initTrees("", "", xpaths, labels, dataTypes, vocs, thes, links);

                    setInputObjRefTree(obj, index, 'setRefEntity');

                }
            }
        }
    };

    $scope.addNewEntity = function (type, index, usedTree) {
        removeExternalEntities(index, usedTree);
        console.log(type);
        if (type !== undefined && type!== "null") {
            $('.input-filter').val('');
//            var targetValue = $("#target").val();
//            var lastO = targetValue.lastIndexOf("/");
//            var collection = targetValue.substring(0, lastO);
//            $('<input type="hidden" name="target" value="' + collection + '/' + type + '"/>').insertAfter($("#target"));
//            console.log("target added");
            if (!sessionStorage[type + lang+ ".xpaths"]) {
                var request = $.ajax({
                    type: "post",
                    url: "GetTerms?category=" + type + "&lang=" + lang + "&action=getListOfTags",
                    async: false
                });
                request.done(function (msg) {
                    sessionStorage[type + lang+ ".xpaths"] = JSON.stringify(msg.xpaths);
                    sessionStorage[type + lang + ".labels"] = JSON.stringify(msg.labels);
                    sessionStorage[type + lang + ".dataTypes"] = JSON.stringify(msg.dataTypes);
                    sessionStorage[type + lang +  ".vocs"] = JSON.stringify(msg.vocTags);
                    sessionStorage[type + lang + ".thes"] = JSON.stringify(msg.thesTags);
                    sessionStorage[type + lang + ".links"] = JSON.stringify(msg.linksTags);

                    var obj = initTrees("", "", msg.xpaths, msg.labels, msg.dataTypes, msg.vocTags, msg.thesTags, msg.linksTags);
                    if (usedTree === 'currentEntity') {
                        setInputObj(obj, index, "addExternal");
                    } else {
                        setInputObjRefTree(obj, index, 'addExternal');
                    }
                });
                request.fail(function (textStatus) {
                    alert("Request failed: " + textStatus);
                });
            } else {
                xpaths = JSON.parse(sessionStorage[type + lang+ ".xpaths"]);
                labels = JSON.parse(sessionStorage[type + lang + ".labels"]);
                dataTypes = JSON.parse(sessionStorage[type + lang + ".dataTypes"]);
                vocs = JSON.parse(sessionStorage[type + lang +  ".vocs"]);
                thes = JSON.parse(sessionStorage[type + lang + ".thes"]);
                links = JSON.parse(sessionStorage[type + lang + ".links"]);
                var obj = initTrees("", "", xpaths, labels, dataTypes, vocs, thes, links);
                if (usedTree === 'currentEntity') {
                    setInputObj(obj, index, "addExternal");
                } else {
                    setInputObjRefTree(obj, index, 'addExternal');

                }
            }
        }
    };


    $scope.removeItem = function (item, usedTree) {
//        var targetValue = $("#target").val();
//        var lastO = targetValue.lastIndexOf("/");
//        var collection = targetValue.substring(0, lastO);
//        $('input[value="' + collection + '/' + item.data[0].id + '"]').remove();
        var index = 0;
        if (usedTree === 'currentEntity') {
            index = $scope.items.indexOf(item);


            removeExternalEntities(index, usedTree);
            $scope.items.splice(index, 1);
        } else {
            index = $scope.refByItems.indexOf(item);
            removeExternalEntities(index, usedTree);
            $scope.refByItems.splice(index, 1);

            for (var i = 0; i < $scope.selValue.length; i++) {
                var found = false;

                for (var j = 0; j < $scope.refByItems.length; j++) {
                    if ($scope.refByItems[j].data[0].id === $scope.selValue[i]) {
                        found = true;

                    }
                }
                if (!found) {
                    var pos = $scope.selValue.indexOf($scope.selValue[i]);
                    $('#refByChosen option[value=' + $scope.selValue[i].toString() + ']').prop('selected', false);
                    $('#refByChosen').trigger('liszt:updated');
                    $scope.selValue.splice(pos, 1);
                    var pos = $scope.previousSelrefByItems.indexOf(item.data[0].id);
                    $scope.previousSelrefByItems.splice(pos, 1);
                }

            }
        }
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
    $scope.showLink = function (value, item) {
        if (value === undefined) {
            return false;
        } else {

            if (value === true) {
                var link = item.link;
                var xpath = item.id;
                if (item.term.length === 0) {
//                    var request = $.ajax({
//                        type: "post",
//                        url: "GetTerms?vocName=" + voc + "&lang=" + lang+"&action=getVocTerms",
//                        async: false
//                    });
                    var request = $.ajax({
                        type: "post",
                        url: "GetTerms?xpath=" + xpath + "&lang=" + lang + "&action=getXpathEntities",
                        async: false
                    });
                    request.done(function (msg) {
                        console.log(JSON.stringify(msg.entities));
                        item.term = JSON.parse(JSON.stringify(msg.entities));
//                    
                    });
                    request.fail(function (textStatus) {
                        //  alert("Request failed: " + textStatus);
                    });
                }
                   if (item.valueLink !== undefined ){
                       item.valueLink = item.valueLink.trim();
                                   console.log("-> "+item.valueLink.trim());}

                   }

            
            return value;

        }
    };

    $scope.showConditionAnd = function (value1, value2, value3) {
        if (value1 === undefined || value2 === undefined || value3 === undefined) {
            return false;
        } else {
            return (value1 && value2 && value3);
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

    $scope.linkSelected = function (term, value) {
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
    $scope.clearOutput = function (items) {
        angular.forEach($scope.output, function (index) {
            var childNodes = getAllChildNodesFromNode(index, []);
            for (var i = 0, len = childNodes.length; i < len; i++) {
                childNodes[i].selected = false;
            }
            index.selected = false;
        });
        $scope.output = angular.copy($scope.output);
    };

    $scope.addTargets = function () {
        var targetValue = $('input[name="target"]:first').val();
        console.log(targetValue);
        var lastO = targetValue.lastIndexOf("/");
        var collection = targetValue.substring(0, lastO);
        console.log(collection);
        $('input[name="target"]:not(:first)').remove();
        console.log("here");
        for (var i = 0; i < $scope.items.length; i++) {
            console.log($scope.items[i].data[0].id + " ---> " + $('input[value="' + collection + '/' + $scope.items[i].data[0].id + '"]').length);
            if ($('input[value="' + collection + '/' + $scope.items[i].data[0].id + '"]').length === 0) {
                console.log("in->" + $scope.items[i].data[0].id);
                $('<input type="hidden" name="target" value="' + collection + '/' + $scope.items[i].data[0].id + '"/>').insertAfter($("#target"));
            }
        }
        for (var i = 0; i < $scope.refByItems.length; i++) {
            if ($('input[value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"]').length === 0) {
                console.log($scope.refByItems[i].data[0].id);

                $('<input type="hidden" name="target" value="' + collection + '/' + $scope.refByItems[i].data[0].id + '"/>').insertAfter($("#target"));
            }
        }
    }

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

        $scope.previousSelrefByItems = [];
        $scope.selValue = [];
        $scope.items = angular.copy($scope.items);
        $scope.refByItems = [];
        $scope.output = angular.copy($scope.output);
    };
});





