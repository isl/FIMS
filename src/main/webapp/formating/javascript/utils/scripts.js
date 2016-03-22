/*
 Copyright 2015 Institute of Computer Science,
 Foundation for Research and Technology - Hellas
 
 Licensed under the EUPL, Version 1.1 or - as soon they will be approved
 by the European Commission - subsequent versions of the EUPL (the "Licence");
 You may not use this work except in compliance with the Licence.
 You may obtain a copy of the Licence at:
 
 http://ec.europa.eu/idabc/eupl
 
 Unless required by applicable law or agreed to in writing, software distributed
 under the Licence is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the Licence for the specific language governing permissions and limitations
 under the Licence.
 
 Contact:  POBox 1385, Heraklio Crete, GR-700 13 GREECE
 Tel:+30-2810-391632
 Fax: +30-2810-391638
 E-mail: isl@ics.forth.gr
 http://www.ics.forth.gr/isl
 
 Authors : Konstantina Konsolaki, Georgios Samaritakis
 
 This file is part of the FIMS webapp.
 */

function getObj(objId) {
    return document.getElementById(objId)
}

function trim(str) {
    return str.replace(/^\s*|\s*$/g, "");
}

function addNewVocTerm(term, url, noTermMsg, termExistsMsg) {
    term = trim(term);
    if (term == '') {
        alert(noTermMsg);
        return false;
    }
    var rows = $("#results").dataTable().fnGetNodes();
    for (var i = 0; i < rows.length; i++)
    {
        if ($(rows[i]).find("td:eq(1) input").val() === term) {
            alert(termExistsMsg + '\'' + term + '\'');
            return false;
        }
    }

    submitFormTo('newTermForm', url);
    return true;
}

function addCriterion(tableBodyId, rowId) {
    var tbody = getObj(tableBodyId);
    var row = getObj(rowId);
    var newRow = row.cloneNode(true);
    tbody.appendChild(newRow);
    newRow = tbody.rows[tbody.rows.length - 1];
    lastRow = tbody.rows[tbody.rows.length - 2];
    var newId = lastRow.cells[0].childNodes[0].value * 1 + 1;
    newRow.cells[0].childNodes[0].value = newId;

    newRow.cells[2].childNodes[1].value = '';
    newRow.cells[4].childNodes[1].style.display = '';


    $("#" + rowId + " select.chosen").removeClass("chzn-done").removeAttr('id').css("display", "block").next().remove();
    $("#" + rowId + " select.chosen").chosen();

    //run through each row
    $('#criteriaBody tr').each(function () {
        // reference all the stuff you need first
        var dataType = $(this).find('#dataTypes').val();

        if (dataType === "string") {
            $(this).find('.string_inputoper').hide();
            $(this).find('.string_inputoper').next().show();
            $(this).find('.time_inputoper').hide();
            $(this).find('.time_inputoper').next().hide();
            $(this).find('.searchString').removeAttr('disabled');
            $(this).find('.timeString').attr('disabled', 'disabled');
            $(this).find('.searchString').show();
            $(this).find('.timeString').hide();
            $(this).find('.timeImg').hide();
        } else if (dataType === "time") {
            $(this).find('.string_inputoper').hide();
            $(this).find('.string_inputoper').next().hide();
            $(this).find('.time_inputoper').hide();
            $(this).find('.time_inputoper').next().show();
            $(this).find('.timeString').removeAttr('disabled');
            $(this).find('.searchString').attr('disabled', 'disabled');
            $(this).find('.searchString').hide();
            $(this).find('.timeString').show();
            $(this).find('.timeImg').show();
        }
    });


    $('.searchValues').change(function (i) {
        var index = $(this).prop('selectedIndex');
        $oper = $(this).parent().children().eq(2);
        $oper.prop('selectedIndex', index);
        var dataType = $oper.val();
        $stingInput = $(this).parent().parent().children().eq(2).children().eq(0);
        $timeInput = $(this).parent().parent().children().eq(2).children().eq(2);

        $searchString = $(this).parent().parent().children().eq(3).children().eq(0);
        $timeString = $(this).parent().parent().children().eq(3).children().eq(1);
        $timeImg = $(this).parent().parent().children().eq(3).children().eq(2);

        if (dataType == "string") {
            $timeInput.hide();
            $timeInput.next().hide();
            $stingInput.hide();
            $stingInput.next().show();

            $searchString.removeAttr('disabled');
            $timeString.attr('disabled', 'disabled');
            $searchString.show();
            $timeString.hide();
            $timeImg.hide();
        } else if (dataType == "time") {
            $timeInput.hide();
            $timeInput.next().show();
            $stingInput.hide();
            $stingInput.next().hide();
            $timeString.removeAttr('disabled');
            $searchString.attr('disabled', 'disabled');
            $searchString.hide();
            $timeString.show();
            $timeImg.show();
        }
    });

}

function addOutput(tableBodyId, rowId) {
    var tbody = getObj(tableBodyId);
    var row = getObj(rowId);
    var newRow = row.cloneNode(true);
    tbody.appendChild(newRow);
}

function removeRow(rowObj) {
    var parent = rowObj.parentNode;
    if (parent.rows.length > 1)
        rowObj.parentNode.removeChild(rowObj);
}

function submitFormTo(formId, formAction) {
    var form = getObj(formId);
    form.action = formAction;
}

function confirmAction(text) {
    return confirm(text);
}


function showInfo(id) {
    getObj('showInfo_' + id).style.display = 'none';
    getObj('info_' + id).style.display = '';
}

function previewPopUp(url, winName) {
    return popUp(url, winName, 900, 700, " ");
}

function popUp(url, winName, w, h) {
    day = new Date();
    id = day.getTime();
    if (isFirefoxOnWindows()) {
        x = window.screenX;
        y = window.screenY;
    } else {
        x = window.screenLeft;
        y = window.screenTop;
    }
    if (w == 850 && h == 500) {
        w = w + 100;
        h = h + 100;
    }
    var plug = false;
    if (url.indexOf("view") == -1) {
        win = window.open(url, winName, 'left=' + x + ',top=' + y + ',width=' + w + ',height=' + h + ',resizable=yes,toolbar=yes,location=no,directories=no,status=no,menubar=yes,scrollbars=yes');
    } else {
        win = window.open(url, winName, 'left=' + x + ',top=' + y + ',width=' + w + ',height=' + h + ',resizable=yes,toolbar=yes,location=no,directories=no,status=no,menubar=no,scrollbars=yes');
    }
    if (win) {
        win.focus();
    }
    else {
        var timer = win.setTimeout(function () {
            if (win)
                win.focus();
        }, 100);
    }

    return w;
}

function popUpWithScroll(url, winName, w, h) {
    day = new Date();
    id = day.getTime();
    x = window.screenLeft;
    y = window.screenTop;
    w = window.open(url, winName, 'left=' + x + ',top=' + y + ',width=' + w + ',height=' + h + ',resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
    w.focus();
    return w;
}

function popUpNoScroll(url, winName, w, h) {
    day = new Date();
    id = day.getTime();
    x = window.screenLeft;
    y = window.screenTop;
    w = window.open(url, winName, 'left=' + x + ',top=' + y + ',width=' + w + ',height=' + h + ',resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no');
    w.focus();
    return w;
}
function timeCheck(timeValue) {

    var str = timeValue.value;
    var Patterns = createPatternsTable(LanguageOfManual);
    for (i = 0; i < Patterns.length; i++) {
        var reg = new RegExp(Patterns[i]);
        if (reg.test(str)) {
            timeValue.style.color = "#000000";
            break;
        } else {
            timeValue.style.color = "#FF0000";
        }
    }
}

function createPatternsTable(language) {

    if (language == "gr") {

        var MonthsPat = "(\\s([ιΙ][αΑ][νΝ][οΟ][υΥ][αάΑ][ρΡ][ιΙ][οΟ][ςΣ]|[φΦ][εΕ][βΒ][ρΡ][οΟ][υΥ][αάΑ][ρΡ][ιΙ][οΟ][ςΣ]|[μΜ][αάΑ][ρΡ][τΤ][ιΙ][οΟ][ςΣ]|[αΑ][πΠ][ρΡ][ιίΙ][λΛ][ιΙ][οΟ][ςΣ]|[μΜ][αάΑ][ιΙϊ][οΟ][ςΣ]|[ιΙ][οΟ][υύΥ][νΝ][ιΙ][οΟ][ςΣ]|[ιΙ][οΟ][υύΥ][λΛ][ιΙ][οΟ][ςΣ]|[αΑ][υύΥ][γΓ][οΟ][υΥ][σΣ][τΤ][οΟ][ςΣ]|[σΣ][εΕ][πΠ][τΤ][εέΕ][μΜ][βΒ][ρΡ][ιΙ][οΟ][ςΣ]|[οΟ][κΚ][τΤ][ωώΩ][βΒ][ρΡ][ιΙ][οΟ][ςΣ]|[νΝ][οΟ][εέΕ][μΜ][βΒ][ρΡ][ιΙ][οΟ][ςΣ]|[δΔ][εΕ][κΚ][εέΕ][μΜ][βΒ][ρΡ][ιΙ][οΟ][ςΣ]))";
        var BChristPat = "(\\s[πΠ]\\.[χΧ]\\.)";
        var AChristPat = "(\\s[μΜ]\\.[χΧ]\\.)";
        var DecadeNoPat = "([πΠ][ρΡ][ωώΩ][τΤ][ηΗ]|[δΔ][εΕ][υύΥ][τΤ][εΕ][ρΡ][ηΗ]|[τΤ][ρΡ][ιίΙ][τΤ][ηΗ]|[τΤ][εέΕ][τΤ][αΑ][ρΡ][τΤ][ηΗ]|[πΠ][εέΕ][μΜ][πΠ][τΤ][ηΗ]|[εέΕ][κΚ][τΤ][ηΗ]|[εέΕ][βΒ][δΔ][οΟ][μΜ][ηΗ]|[οόΟ][γΓ][δΔ][οΟ][ηΗ]|[εέΕ][νΝ][αΑ][τΤ][ηΗ]|[δΔ][εέΕ][κΚ][αΑ][τΤ][ηΗ]|[τΤ][εΕ][λΛ][εΕ][υΥ][τΤ][αΑ][ιίΙ][αΑ])";
        var DecadePat = "[δΔ][εΕ][κΚ][αΑ][εΕ][τΤ][ιίΙ][αΑ]";
        var OfPat = "[τΤ][οΟ][υΥ]";
        var OuPat = "ου";
        var OsPat = "ος"
        var CenturyPat = "[αΑ][ιΙ][ωώΩ][νΝ][αΑ]";
        var Century2Pat = "[αΑ][ιΙ][ωώΩ][νΝ][αΑ][ςΣ]";
        var CenturyPart1Pat = "[αΑ][ρΡ][χΧ][εέΕ][ςΣ]|[μΜ][εέΕ][σΣ][αΑ]|[τΤ][εέΕ][λΛ][ηΗ]";
        var HalfPat = "[μΜ][ιΙ][σΣ][οόΟ]";
        var QuarterPat = "[τΤ][εέΕ][τΤ][αΑ][ρΡ][τΤ][οΟ]";
        var HalfNoPat = "(α|β)'";
        var QuarterNoPat = "(α|β|γ|δ)'";
    } else if (language == "en") {
        var MonthsPat = "(\\s([jJ][aA][nN][uU][aA][rR][yY]|[fF][eE][bB][rR][uU][aA][rR][yY]|[mM][aA][rR][cC][hH]|[aA][pP][rR][iI][lL]|[mM][aA][yY]|[jJ][uU][nN][eE]|[jJ][uU][lL][yY]|[aA][uU][gG][uU][sS][tT]|[sS][eE][pP][tT][eE][mM][bB][eE][rR]|[oO][cC][tT][oO][bB][eE][rR]|[nN][oO][vV][eE][mM][bB][eE][rR]|[dD][eE][cC][eE][mM][bB][eE][rR]))";
        var BChristPat = "(\\s[bB][cC][eE])";
        var AChristPat = "(\\s[cC][eE])";
        var DecadeNoPat = "([fF][iI][rR][sS][tT]|[sS][eE][cC][oO][nN][dD]|[tT][hH][iI][rR][dD]|[fF][oO][uU][rR][tT][hH]|[fF][iI][fF][tT][hH]|[sS][iI][xX][tT][hH]|[sS][eE][vV][eE][nN][tT][hH]|[eE][iI][gG][hH][tT][hH]|[nN][iI][nN][tT][hH]|[tT][eE][nN][tT][hH] |[lL][aA][sS][tT])";
        var DecadePat = "[dD][eE][cC][aA][dD][eE]";
        var OfPat = "[oO][fF]";
        var OuPat = "th|[1]st|[2]nd|3rd";
        var OsPat = "th|[1]st|[2]nd|3rd"
        var CenturyPat = "[cC][eE][nN][tT][uU][rR][yY]";
        var Century2Pat = "[cC][eE][nN][tT][uU][rR][yY]";
        var CenturyPart1Pat = "[eE][aA][rR][lL][yY]|[mM][iI][dD]|[lL][aA][tT][eE]";
        var HalfPat = "[hH][aA][lL][fF]";
        var QuarterPat = "[qQ][uU][aA][rR][tT][eE][rR]";
        var HalfNoPat = "(1st|2nd)";
        var QuarterNoPat = "(1st|2nd|3rd|4th)";
    }
//ui patterns
    var PatternBCFullEnd = BChristPat + "?$";
    var PatternACFullEnd = AChristPat + "$";
    var Pavla = "\\s+-\\s+";
    //No Christ Patterns-Basic combos
    var Pattern1 = "\\d{1,4}?" + MonthsPat + "?(\\s([12]\\d|3[01]|[1-9]))?";
    var Pattern2 = "(" + DecadeNoPat + "+\\s)?" + DecadePat + "\\s" + OfPat + " ((\\d{1,3}" + OuPat + ")\\s" + CenturyPat + "|\\d{1,4})";
    var Pattern3 = "(\\d{1,3}" + OsPat + ")\\s" + Century2Pat;
    var Pattern4 = "(" + CenturyPart1Pat + "|" + HalfNoPat + "\\s" + HalfPat + "|" + QuarterNoPat + "\\s" + QuarterPat + ")\\s(\\d{1,3}" + OuPat + ")\\s" + CenturyPat;
    var Pattern5 = "\\d{1,4}\\s,\\sca\\.";
    var Patterns = new Array()
    Patterns[0] = "^\\s*$";
    Patterns[1] = "^" + Pattern1 + PatternBCFullEnd;
    Patterns[2] = "^" + Pattern2 + PatternBCFullEnd;
    Patterns[3] = "^" + Pattern3 + PatternBCFullEnd;
    Patterns[4] = "^" + Pattern1 + Pavla + Pattern1 + PatternBCFullEnd;
    Patterns[5] = "^" + Pattern1 + Pavla + Pattern2 + PatternBCFullEnd;
    Patterns[6] = "^" + Pattern1 + Pavla + Pattern3 + PatternBCFullEnd;
    Patterns[7] = "^" + Pattern2 + Pavla + Pattern1 + PatternBCFullEnd;
    Patterns[8] = "^" + Pattern2 + Pavla + Pattern2 + PatternBCFullEnd;
    Patterns[9] = "^" + Pattern2 + Pavla + Pattern3 + PatternBCFullEnd;
    Patterns[10] = "^" + Pattern3 + Pavla + Pattern1 + PatternBCFullEnd;
    Patterns[11] = "^" + Pattern3 + Pavla + Pattern2 + PatternBCFullEnd;
    Patterns[12] = "^" + Pattern3 + Pavla + Pattern3 + PatternBCFullEnd;
    Patterns[13] = "^" + Pattern4 + PatternBCFullEnd;
    Patterns[14] = "^" + Pattern5 + PatternBCFullEnd;
    Patterns[15] = "^" + Pattern1 + BChristPat + Pavla + Pattern1 + AChristPat + "$";
    Patterns[16] = "^" + Pattern1 + BChristPat + Pavla + Pattern2 + AChristPat + "$";
    Patterns[17] = "^" + Pattern1 + BChristPat + Pavla + Pattern3 + AChristPat + "$";
    Patterns[18] = "^" + Pattern1 + BChristPat + Pavla + Pattern4 + AChristPat + "$";
    Patterns[19] = "^" + Pattern1 + BChristPat + Pavla + Pattern5 + AChristPat + "$";
    Patterns[20] = "^" + Pattern2 + BChristPat + Pavla + Pattern1 + AChristPat + "$";
    Patterns[21] = "^" + Pattern2 + BChristPat + Pavla + Pattern2 + AChristPat + "$";
    Patterns[22] = "^" + Pattern2 + BChristPat + Pavla + Pattern3 + AChristPat + "$";
    Patterns[23] = "^" + Pattern2 + BChristPat + Pavla + Pattern4 + AChristPat + "$";
    Patterns[24] = "^" + Pattern2 + BChristPat + Pavla + Pattern5 + AChristPat + "$";
    Patterns[25] = "^" + Pattern3 + BChristPat + Pavla + Pattern1 + AChristPat + "$";
    Patterns[26] = "^" + Pattern3 + BChristPat + Pavla + Pattern2 + AChristPat + "$";
    Patterns[27] = "^" + Pattern3 + BChristPat + Pavla + Pattern3 + AChristPat + "$";
    Patterns[28] = "^" + Pattern3 + BChristPat + Pavla + Pattern4 + AChristPat + "$";
    Patterns[29] = "^" + Pattern3 + BChristPat + Pavla + Pattern5 + AChristPat + "$";
    Patterns[30] = "^" + Pattern4 + BChristPat + Pavla + Pattern1 + AChristPat + "$";
    Patterns[31] = "^" + Pattern4 + BChristPat + Pavla + Pattern2 + AChristPat + "$";
    Patterns[32] = "^" + Pattern4 + BChristPat + Pavla + Pattern3 + AChristPat + "$";
    Patterns[33] = "^" + Pattern4 + BChristPat + Pavla + Pattern4 + AChristPat + "$";
    Patterns[34] = "^" + Pattern4 + BChristPat + Pavla + Pattern5 + AChristPat + "$";
    Patterns[35] = "^" + Pattern5 + BChristPat + Pavla + Pattern1 + AChristPat + "$";
    Patterns[36] = "^" + Pattern5 + BChristPat + Pavla + Pattern2 + AChristPat + "$";
    Patterns[37] = "^" + Pattern5 + BChristPat + Pavla + Pattern3 + AChristPat + "$";
    Patterns[38] = "^" + Pattern5 + BChristPat + Pavla + Pattern4 + AChristPat + "$";
    Patterns[39] = "^" + Pattern5 + BChristPat + Pavla + Pattern5 + AChristPat + "$";
    return Patterns;
}

function isFirefoxOnWindows() {
    return ((navigator.userAgent.indexOf("Firefox") != -1) && (navigator.userAgent.indexOf("Win") != -1));
}

// return true if the page loads in Internet Explorer
function isIEOnWindows() {
    return ((navigator.userAgent.indexOf('MSIE') != -1) && (navigator.userAgent.indexOf('Win') != -1))
}

//return true if Browser is 64bit
function is64bitBrowser() {
    return ((navigator.userAgent.indexOf('Win64') != -1) && (navigator.userAgent.indexOf('x64') != -1))
}

function replaceAll(txt, replace, with_this) {
    return txt.replace(new RegExp(replace, 'g'), with_this);
}


function toggleVisibility(id) {
    if (id.style.display == 'block')
        id.style.display = 'none';
    else
        id.style.display = 'block';
}

var popupWindow = null;
function centeredPopup(url, winName, w, h, scroll) {
    LeftPosition = (screen.width) ? (screen.width - w) / 2 : 0;
    TopPosition = (screen.height) ? (screen.height - h) / 2 : 0;
    settings =
            'height=' + h + ',width=' + w + ',top=' + TopPosition + ',left=' + LeftPosition + ',scrollbars=' + scroll + ',resizable'
    popupWindow = window.open(url, winName, settings)
}

function confirmActionRestore(text, date, time) {
    return confirm(text + date + "[ " + time + " ]");
}