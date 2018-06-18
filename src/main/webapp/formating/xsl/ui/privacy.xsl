<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : about.xsl
    Created on : July 19, 2017, 1:32 PM
    Author     : konsolak
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>
    <xsl:include href="page.xsl"/>

    <xsl:template match="/">
        <xsl:call-template name="page"/>
    </xsl:template>
    <xsl:template name="context">
        <div class="w3-container w3-white w3-padding-24" style="margin-top:20px;">
            <div class="w3-row">
                <div class="w3-col">   
                    <xsl:choose>
                        <xsl:when test="//action='conditions'">
                            <xsl:choose>
                                <xsl:when test="$lang='gr'">
                                    <b>Ι.Τ.Ε. ΓΕΝΙΚΟΙ ΟΡΟΙ ΧΡΗΣΗΣ ΙΣΤΟΤΟΠΟΥ ΙΤΕ</b>


                                    <p>Το περιεχόμενο του ιστοτόπου του Ιδρύματος Τεχνολογίας και Έρευνας (ΙΤΕ) συμπεριλαμβανομένων και των ιστοσελίδων όλων των Ινστιτούτων, εργαστηρίων, μονάδων, υποδομών του ΙΤΕ, που στο σύνολό τους αναφέρονται εφεξής στο παρόν ως ‘ΙΤΕ Ιστότοπος’, υπόκειται στους παρόντες γενικούς όρους χρήσης και στους ειδικότερους ανά ιστότοπο-ιστοσελίδα των Ινστιτούτων, εργαστηρίων, οργάνων, υποδομών του ΙΤΕ όρους χρήσης, δεσμεύουν καθέναν που χρησιμοποιεί και αποκτά πρόσβαση σε αυτόν τον ΙΤΕ ιστότοπο, υπό οποιαδήποτε εκδοχή και έκφανσή του. Το ΙΤΕ μπορεί να τροποποιήσει τους παρόντες Όρους Χρήσης οποτεδήποτε και χωρίς προειδοποίηση, ανακοινώνοντας οποιαδήποτε τέτοια τροποποίηση μέσω του διαδικτυακού τόπου του. Με την πλοήγηση και χρήση του ιστοτόπου του ΙΤΕ, οι επισκέπτες/χρήστες αναγνωρίζουν ότι έχουν διαβάσει, κατανοήσει και ανεπιφύλακτα αποδεχθεί τους Όρους Χρήσης. Η χρήση του ιστοτόπου του ΙΤΕ ύστερα από την ανακοίνωση της τροποποίησης θα θεωρείται ότι αποτελεί αποδοχή της εν λόγω τροποποίησης εκ μέρους του επισκέπτη/χρήστη. Η χρήση του ΙΤΕ διαδικτυακού τόπου πρέπει να γίνεται σύμφωνα με τους εκάστοτε εν ισχύ Όρους Χρήσης και εφαρμοστέο δίκαιο.</p>

                                    <b>Δικαιώματα Πνευματικής Ιδιοκτησίας</b>

                                    <p>Όλο το περιεχόμενο του ΙΤΕ ιστοτόπου (όπως εικόνων, γραφικών, φωτογραφιών, σχεδίων, κειμένων, δεδομένων, βάσεων δεδομένων, προγραμμάτων η/υ, εφαρμογών, παρεχομένων υπηρεσιών, κλπ. και γενικά όλων των δεδομένων, αρχείων αυτού του ιστοτόπου και η δομή του), αποτελούν τμήμα της διανοητικής ιδιοκτησίας του ΙΤΕ και προστατεύονται κατά το εκάστοτε εν ισχύ δίκαιο και σχετικές διατάξεις για την προστασία της διανοητικής ιδιοκτησίας.</p>
                                    <p>
                                        Με την επιφύλαξη όλων των διατάξεων, όρων και νόμιμων περιορισμών που προβλέπει το εφαρμοστέο δίκαιο διανοητικής ιδιοκτησίας και δη πνευματικής ιδιοκτησίας (βλ. Ν.2121/1993 όπως ισχύει) επιτρέπονται οι εκ του νόμου και σύμφωνες με τα χρηστά ήθη προβλεπόμενες ως επιτρεπόμενες νόμιμες ενέργειες, χρήση, (πχ αναπαραγωγή για ιδιωτική χρήση σύντομων αποσπασμάτων τμήματος, μέρους του ΙΤΕ περιεχομένου στον ισότοπό του, αναπαραγωγή για διδασκαλία/έρευνα) κι εφόσον δεν ενεργούνται για εμπορική ή άλλου κερδοσκοπικού χαρακτήρα χρήση, συνοδεύονται πάντα από την ένδειξη και αναφορά της/στον ΙΤΕ ιστοτόπο, πηγής, ονομάτων, και δικαιωμάτων διανοητικής ιδιοκτησίας του ΙΤΕ. Οποιαδήποτε χρήση του περιεχομένου του ιστοτόπου από την χρήστη/επισκέπτη, θα πρέπει να αναφέρει ευκρινώς την πηγή της προέλευσής του.</p>
                                    <p>
                                        Το ΙΤΕ δεν ευθύνεται για τυχόν παραβίαση δικαιωμάτων διανοητικής ιδιοκτησίας ή άλλων δικαιωμάτων τρίτων που αφορά πληροφορίες ή υλικό που παρανόμως έχει αναρτηθεί στον ιστότοπό του ή που έχουν αναρτηθεί από/με μη εξουσιοδοτημένα, ή μη νόμιμα, πρόσωπα/μέσα/μηχανισμούς.</p>

                                    <b>Προστασία Προσωπικών Δεδομένων</b>

                                    <p>Η επεξεργασία και προστασία των προσωπικών δεδομένων των επισκεπτών/χρηστών του παρόντος ιστοστόπου υπόκειται στους κανόνες που ορίζει το εκάστοτε εν ισχύ εθνικό, ενωσιακό και διεθνές δίκαιο για την επεξεργασία δεδομένων προσωπικού χαρακτήρα.</p>
                                    <p>
                                        Το ΙΤΕ διαθέτει ηλεκτρονική φόρμα επικοινωνίας όπου ο χρήστης/επισκέπτης οικειοθελώς μπορεί να παράσχει κάποια προσωπικά του δεδομένα όπως είναι το ονοματεπώνυμο, η ιδιότητα, τα στοιχεία του οργανισμού, η διεύθυνση ηλεκτρονικού ταχυδρομείου (e-mail), o αριθμός τηλεφώνου και η ταχυδρομική διεύθυνση. Το ΙΤΕ συλλέγει μόνο τα δεδομένα προσωπικού χαρακτήρα που είναι απαραίτητα για την επικοινωνία με τον επισκέπτη/χρήστη και τα χρησιμοποιεί αποκλειστικά για αυτόν τον σκοπό και για όσο χρονικό διάστημα είναι απαραίτητο.</p>
                                    <p>
                                        Το ΙΤΕ σε καμία περίπτωση δεν συλλέγει δεδομένα προσωπικού χαρακτήρα που εντάσσονται σε ειδικές κατηγορίες προσωπικών δεδομένων όπως η φυλετική ή εθνική καταγωγή, δεδομένα που αφορούν θρησκευτικές πεποιθήσεις ή πολιτικά φρονήματα κ.α.</p>
                                    <p>
                                        Ο επισκέπτης/ χρήστης μπορεί να αναζητήσει περισσότερες πληροφορίες αναφορικά με την επεξεργασία και την προστασία προσωπικών δεδομένων στην «Πολιτική Προστασίας Προσωπικών Δεδομένων» του παρόντος ιστοτόπου.</p>
                                    <p>
                                        Ο επισκέπτης/χρήστης του παρόντος ιστοτόπου έχει τη δυνατότητα να επικοινωνήσει με τον Υπεύθυνο Προστασίας Δεδομένων (ΥΠΔ) του ΙΤΕ προκειμένου να ενημερωθεί για την τυχόν τήρηση προσωπικών του στοιχείων και να ασκήσει τα δικαιώματά του (όπως δικαίωμα πρόσβασης, διόρθωσης, επικαιροποίησης, διαγραφής, κλπ). Ο επισκέπτης/χρήστης μπορεί να επικοινωνήσει με τον ΥΠΔ στο <a href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.</p>

                                    <b>Πολιτική για Cookies</b>

                                    <p>Κατά την πλοήγηση στον παρόντα ιστότοπο, το ΙΤΕ ενδέχεται να συγκεντρώνει στοιχεία αναγνώρισης των χρηστών χρησιμοποιώντας αντίστοιχες τεχνολογίες, όπως cookies ή/και την παρακολούθηση διευθύνσεων Πρωτοκόλλου Internet (IP). Τα cookies είναι μικρά τμήματα κειμένου που αποστέλλονται στο πρόγραμμα περιήγησης από έναν ιστότοπο που επισκέπτεται ο χρήστης. Η χρήση των cookies διευκολύνει τον ιστότοπο να απομνημονεύει πληροφορίες σχετικά με την επίσκεψη του χρήστη, όπως π.χ την προτιμώμενη γλώσσα σας, την απομνημόνευση των προτιμήσεών σας, όσον αφορά στην ασφαλή αναζήτηση, τον υπολογισμό του αριθμού των επισκεπτών ή τη διευκόλυνση της εγγραφής στις υπηρεσίες μας.</p>
                                    <p>

                                        <b>Πώς να ελέγχετε τα cookies:</b> Μπορείτε να ελέγχετε και/ή να διαγράφετε τα cookies ανάλογα με τις επιθυμίες σας. Λεπτομέρειες θα βρείτε εδώ: aboutcookies.org. Μπορείτε να διαγράψετε όλα τα cookies που βρίσκονται ήδη στον υπολογιστή σας, όπως και να ρυθμίσετε τους περισσότερους φυλλομετρητές κατά τρόπο που να μην επιτρέπουν την εγκατάσταση cookies. Ωστόσο, στην περίπτωση αυτή, ίσως χρειαστεί να προσαρμόζετε εσείς από μόνοι σας ορισμένες προτιμήσεις κάθε φορά που επισκέπτεστε έναν ιστότοπο Ο χρήστης δύναται να κάνει χρήση του ιστοτόπου χωρίς προβλήματα και χωρίς τη χρήση των cookies αλλά ενδεχομένως εις βάρος της ευχρηστίας του και της λειτουργίας ορισμένων υπηρεσιών αυτού.</p>

                                    <b>Περιορισμός ευθύνης του ΙΤΕ</b>

                                    <p>Στόχος του παρόντος ιστοτόπου είναι η βέλτιστη ενημέρωση του επισκέπτη/χρήστη.
                                        Το επίπεδο ασφαλείας είναι ανάλογο ενός ερευνητικού οργανισμού του ευρύτερου δημοσίου τομέα και ακαδημαϊκού περιβάλλοντος και το ΙΤΕ καταβάλλει κάθε προσπάθεια για την πλήρη και τεχνικά απρόσκοπτη και ασφαλή λειτουργία του ιστοτόπου. Το ΙΤΕ δεν εγγυάται ότι οι υπηρεσίες του παρόντος ιστοτόπου και οι επιμέρους σελίδες του θα παρέχονται αδιαλείπτως και χωρίς σφάλματα.</p>
                                    <p>
                                        Το ΙΤΕ δεν εγγυάται ότι ο παρών ιστότοπος ή οποιοσδήποτε άλλος συγγενικός δικτυακός τόπος ή οι εξυπηρετητές ("servers") μέσω των οποίων το περιεχόμενο τίθεται στη διάθεση των επισκεπτών/χρηστών παρέχονται χωρίς "ιούς" ή άλλα επιζήμια συστατικά.</p>
                                    <p>
                                        Το ΙΤΕ δεν ευθύνεται για τυχόν λάθη, παραλείψεις ή άλλα ελαττώματα, καθυστερήσεις ή διακοπές στην παροχή των δεδομένων του ιστοτόπου, ή για οποιεσδήποτε ενέργειες που σχετίζονται με την αξιοποίηση αυτών των δεδομένων ή απορρέουν από αυτή.</p>
                                    <p>
                                        Το ΙΤΕ δεν εγγυάται και δεν ευθύνεται για την ακρίβεια, την ορθότητα, την επάρκεια ή την πληρότητα και την επικαιροποίηση του περιεχομένου του παρόντος ιστοτόπου.</p>
                                    <p>
                                        Το ΙΤΕ δεν φέρει σε καμία περίπτωση ευθύνη για οποιαδήποτε ζημία, άμεση και έμμεση ζημία από ποινική δίωξη που προκύπτει ή απορρέει από την (παράνομη) πρόσβαση και την (παράνομη) χρήση ή την άνευ προγενέστερης σχετικής έγγραφης άδειας εκ μέρους του ΙΤΕ οποιουδήποτε μέρους, τμήματος του περιεχομένου του ΙΤΕ ιστότοπου, υπηρεσιών, επιλογών, που διατίθενται δια του παρόντος (ΙΤΕ) ιστοτόπου, όπου δε τυχόν απορρέοντα έξοδα, μέτρα, τυχόν χρειαστεί να ληφθούν εκ μέρους του ΙΤΕ θα επιβαρύνουν το εκάστοτε υπόχρεο πρόσωπο.</p>

                                    <b>Χρήση ιστοσελίδων τρίτων φορέων</b>

                                    <p>Ο παρών ιστότοπος ενδέχεται να περιέχει «συνδέσμους» σε άλλους δικτυακούς τόπους. O δικτυακός τόπος www.forth.gr δεν ελέγχει τη διαθεσιμότητα, το περιεχόμενο, την πολιτική προστασίας των προσωπικών δεδομένων, την ποιότητα και την πληρότητα των υπηρεσιών άλλων δικτυακών τόπων, στους οποίους παραπέμπει μέσω "συνδέσμων", «υπερκειμενικών συνδέσμων» (hyperlinks) ή ηλεκτρονικών διαφημιστικών πινακίδων (banners) και δεν ευθύνεται για αυτά. O δικτυακός τόπος www.forth.gr σε καμία περίπτωση δεν πρέπει να θεωρηθεί ότι ενστερνίζεται ή αποδέχεται το περιεχόμενο ή τις υπηρεσίες των δικτυακών τόπων και των σελίδων στα οποία παραπέμπει ή ότι συνδέεται με αυτά κατά οποιονδήποτε άλλο τρόπο.</p>
                                    <p>
                                        Το ΙΤΕ δεν εγγυάται και δεν φέρει ευθύνη ως προς το περιεχόμενο και τη λειτουργία συνδέσμων που διατίθενται μέσω αυτού ή στους οποίους αυτό παραπέμπει.</p>
                                    <p>
                                        Ο δικτυακός τόπος ενδέχεται να περιέχει «συνδέσμους» σε άλλους δικτυακούς τόπους ή να κάνει χρήση ιστοσελίδων (links). To ITE δεν ελέγχει τη διαθεσιμότητα, το περιεχόμενο, την πολιτική προστασίας των προσωπικών δεδομένων, την ποιότητα και την πληρότητα των υπηρεσιών άλλων δικτυακών τόπων, στους οποίους παραπέμπει μέσω "συνδεσμών", «υπερκειμενικών συνδέσμων» (hyperlinks).
                                        To ITE σε καμία περίπτωση δεν πρέπει να θεωρηθεί ότι ενστερνίζεται ή αποδέχεται το περιεχόμενο ή τις υπηρεσίες των δικτυακών τόπων και των σελίδων στα οποία παραπέμπει ή ότι συνδέεται με αυτά κατά οποιονδήποτε άλλο τρόπο.</p>
                                    <p>
                                        Συνεπώς, το ΙΤΕ δεν φέρει καμία ευθύνη για τυχόν ζημία που θα υποστεί ο χρήστης/επισκέπτης από την χρήση ιστοσελίδων τρίτων φορέων. Οι σύνδεσμοι αυτοί χρησιμοποιούνται με αποκλειστική ευθύνη του χρήστη/επισκέπτη και η πρόσβαση σε αυτούς τους δικτυακούς τόπους και η χρήση αυτών υπόκειται στους όρους, τους οποίους αυτοί έχουν προσδιορίσει. Συνεπώς για οποιοδήποτε ερώτημα ή/και πρόβλημα παρουσιασθεί κατά την επίσκεψη/χρήση τους, οφείλετε να απευθύνεστε απευθείας στους αντίστοιχους δικτυακούς τόπους και σελίδες, οι οποία και φέρουν τη σχετική ευθύνη για την παροχή των υπηρεσιών τους.</p>

                                    <b>Εφαρμοστέο δίκαιο</b>

                                    <p>Οι όροι και προϋποθέσεις χρήσης του παρόντος ιστοτόπου καθώς και οποιαδήποτε τροποποίηση ή αλλαγή τους διέπονται από το εθνικό, Ενωσιακό και διεθνές δίκαιο. Διατάξεις των όρων χρήσης που τυχόν αντίκεινται με το ως άνω νομικό πλαίσιο, παύουν αυτοδικαίως να ισχύουν και αφαιρούνται από την ιστοσελίδα χωρίς να θίγεται η ισχύς των λοιπών όρων χρήσης.</p>
                                    <p>
                                        Οι παρόντες όροι χρήσης ενέχουν τη θέση συμφωνίας μεταξύ του διαχειριστή και του επισκέπτη/χρήστη του ιστοτόπου. Κάθε τροποποίηση της συμφωνίας αυτή προκειμένου να έχει ισχύ θα πρέπει να διατυπώνεται εγγράφως.</p>
                                    <p>
                                        Τυχόν διαφορές που θα προκύψουν από την εφαρμογή των παρόντων όρων χρήσης και γενικότερα από τη χρήση του ιστοτόπου από τον επισκέπτη/χρήστη και οι οποίες δεν μπορούν να επιλυθούν φιλικά, διέπονται από το ελληνικό δίκαιο και υπάγονται στη δικαιοδοσία των Δικαστηρίων του Ηρακλείου.</p>

                                    <b>Επικοινωνία</b>

                                    <p>Προκειμένου να επικοινωνήσετε για θέματα περιεχομένου του ιστοτόπου ΙΤΕ παρακαλούμε όπως αποστείλατε ηλεκτρονικό μήνυμα στο <a href="mailto:central@admin.forth.gr">central@admin.forth.gr</a>.</p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <b>FORTH WEBSITE GENERAL TERMS OF USE</b>

                                    <p>The content(s) of any and all website(s) of the Foundation for Research and Technology – Hellas (FO.R.T.H.), including FORTH research institutes’ and facilities’ websites, hereafter all referred to as ‘FORTH website’ is/are subject to the present general terms and conditions of use in addition to any other specific on any part of FORTH website(s) terms and conditions that are all binding upon anyone who uses and has access to it, in any version and form thereof. FORTH may modify these Terms of Use at any time, without previous notice, by announcing any such modification on its website. By navigating on and using the FORTH website, visitors/users acknowledge that they have read, understood and unconditionally accepted the Terms of Use. Use of the FORTH website following announcement of a modification shall be regarded as acceptance of the said modification by the visitor/user. Use of the FORTH website must be in accordance with all applicable laws and these Terms of Use as in force at any time.</p>

                                    <b>Intellectual Property Rights</b>

                                    <p>All contents of FORTH website (such as pictures, graphics, photographs, drawings, texts, data, databases, computer programs, applications, services, etc. provided and, in general, all items, data, files of this website) and its structure constitutes intellectual/industrial property of FORTH is owned by FORTH and is protected under the relevant provisions on the protection of intellectual and industrial property, in accordance with Greek law, EU law and the international conventions and treaties, as applicable. Without prejudice to the use for research and teaching purposes, website visitors may use the contents only for personal use (fair use) purposes; Commercial or any other profit making use of shall not be permitted in any event. Publication, presentation, reproduction, distribution, broadcasting or any other use or exploitation of the contents of the FORTH website, in part or in whole, shall not be permitted in any manner whatsoever without the FORTH’ prior consent in writing. Any use of any of the FORTH website(s) contents by the user/visitor must clearly refer to the said source. FORTH shall not be held liable for violation of any intellectual/industrial property rights or other third parties’ rights as a result of visitors/users’ misappropriation of, unlawful use, access to FORTH website(s), content, services, upload, use of, by non authorized/legal, persons/means/mechanisms.</p>

                                    <b>Personal Data Protection</b>

                                    <p>The processing and protection of visitors’/users’ personal data of FORTH website shall be subject to the rules set out in national, EU and international law on the processing of personal data. FORTH has an online contact form on which visitors/users may voluntarily provide any of their personal data, such as name, quality, details of organisation, email address, telephone number and postal address. FORTH shall collect only personal data that are necessary for communicating with the visitors/users and use such data exclusively for that purpose and for as long as it is necessary. FORTH shall in no case collect personal data falling within special categories of personal data, such as racial or ethnic origin, data related to religion, political opinion, etc. Visitors/users may search for more information relating to personal data protection and processing in ‘Personal Data Protection Policy’ in this website. Visitors/users of this website may contact the FORTH Personal Data Officer (PDO) in order to receive information about storage/use of their personal data and to exercise their rights (such as the right of access, rights to rectification, erasure, etc.). Visitors/users may contact the DPO at <a target="_blank"  href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.</p>

                                    <b>Cookies Policy</b>

                                    <p>During visitors’/users’ navigation on FORTH website, FORTH may collect identification data of users, by using relevant technologies, such as cookies and/or Internet Protocol (IP) address monitoring. Cookies are small text segments that are sent to the browser by a website visited by the user. The use of cookies helps the website to remember information about the user’s visit, such as your preferred language and your preferences, to make secure searches, to calculate the number of visitors, or to facilitate your registration in our services. </p>
                                    <p>
                                        <b>How to control cookies:</b> You may control and/or delete cookies as you wish. You may find more details at about cookies.org. You may delete all cookies from your computer and, in most browsers, select settings that do not allow installation of cookies. However, in that case, you may have to adjust certain preferences any time you visit a website. Users may make use of the website without problems even without use of cookies, but, potentially, to the detriment of its userfriendliness and of the functioning of certain of its services.
                                    </p>
                                    <b>Limitation of FORTH’s Liability</b>
                                    <p>
                                        The purpose of this website is to provide best information to visitors/users. The security level is commensurate with public sector research organisations’ and academic environments and FORTH makes all reasonable efforts to ensure full and technically sound and secure functioning of the website. FORTH does not warrant that the services of this website and its individual web pages shall be provided without interruptions and without errors. FORTH does not warrant that this website or any other related website or servers through which content is made available to visitors/users are provided free of viruses or other harmful components. FORTH may not be held liable for any errors, omissions, or other defects, delays or interruptions in the provision of the data of the website, or for any actions related to the utilisation of these data or deriving therefrom. FORTH does not warrant and may not be held liable for the accuracy, correctness, adequacy or completeness and updating of the content of this website. FORTH shall in no event be held liable for any damage, direct, indirect, liquidated, consequential, negative difference, loss entailed by criminal proceedings, which is caused by or derives from the unauthorized, unlawful, access to and/or use of the FORTH website’s content, services, options whereas any such raised damages, expenses, costs, remedies
                                        needed to be taken by FORTH shall be borne by the person held liable to as the case may be.</p>

                                    <b>Use of Third Party Websites</b>

                                    <p>This website may contain links to other websites of which FORTH does not control the availability, content, personal data protection policy, quality and completeness of the services provided on other websites referred to through links, hyperlinks or banners, and does not assume any responsibility for them. shall in no way be regarded as adopting or accepting the content or the services of the web sites and pages which it links to or is being connected to, in any way. FORTH does not warrant and may not be held liable for the content and functioning of links provided on or referred to on its website. The website may contain links to other websites and make use of web pages (links). FORTH does not control the availability, content, personal data protection policy, quality and completeness of services provided on other websites referred to through links or hyperlinks. FORTH shall in no way be regarded as adopting or accepting the content or the services of the web sites and pages which it links to or is being connected to, in any way. Therefore, FORTH shall not assume any liability for any damage suffered by the visitor/user as a result of the use of third parties’ web pages. These links shall be used in the exclusive responsibility of the visitor/user, and access to them and use thereof shall be subject to the terms specified on them. Therefore, for any question or problem arising during the visit to or use of such, the visitor/user must directly address such instance to the respective web sites and pages, which shall also assume fully the relevant responsibility for the provision of their services.</p>

                                    <b>Applicable Law</b>

                                    <p>The terms and conditions of use of this website, as well as any modification or change thereof shall be governed by all applicable laws. Provisions in the terms of use that may contravene the above legal framework shall cease to be effective ipso jure and be removed from the web page, without affecting the validity of the other terms of use. These terms of use shall serve as an agreement between FORTH and the visitor/user of FORTH website. Any disputes that may arise from the implementation of these terms of use and, in general, from the use of the FORTH website by the visitor/user, which cannot be resolved amicably, shall be governed by Greek law and fall within the competence of the Courts of Heraklion, Crete, Greece.</p>

                                    <b>Contact</b>

                                    <p>If you wish to contact us for matters related to FORTH website terms and conditions, you are kindly requested to send an e-mail at <a  target="_blank"  href="mailto:central@admin.forth.gr">central@admin.forth.gr</a>.</p>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$lang='gr'">
                                    <b>ΠΟΛΙΤΙΚΗ ΠΡΟΣΤΑΣΙΑΣ ΔΕΔΟΜΕΝΩΝ ΠΡΟΣΩΠΙΚΟΥ ΧΑΡΑΚΤΗΡΑ </b>

                                    <p>To Ίδρυμα Τεχνολογίας Έρευνας (ΙΤΕ) αποδίδει ιδιαίτερη σημασία στην προστασία της ιδιωτικότητας και των δεδομένων προσωπικού χαρακτήρα των επισκεπτών/χρηστών. Επισημαίνεται ότι ως δεδομένα προσωπικού χαρακτήρα νοούνται από την οικεία νομοθεσία (Γενικός Κανονισμός Προστασίας Δεδομένων 2016/679/ΕΕ) μόνο εκείνες οι πληροφορίες που αφορούν ένα προσδιορισμένο ή – επί τη βάσει κάποιων χαρακτηριστικών – προσδιορίσιμο φυσικό πρόσωπο (υποκείμενο των δεδομένων). Πληροφορίες που αφορούν νομικά πρόσωπα και ομάδες προσώπων ή πληροφορίες στατιστικού χαρακτήρα, από τις οποίες δεν είναι δυνατή η αναγωγή σε προσδιορισμένο ή προσδιορίσιμο φυσικό πρόσωπο, δεν εμπίπτουν σε αυτήν την κατηγορία και εξαιρούνται από το πεδίο εφαρμογής της σχετικής νομοθεσίας. </p>
                                    <p>
                                        Η παρούσα πολιτική προστασίας Προσωπικών Δεδομένων είναι απολύτως συμβατή με τον Ευρωπαϊκό Κανονισμό για την προστασία των φυσικών προσώπων έναντι της επεξεργασίας των δεδομένων προσωπικού χαρακτήρα (ΕΕ/2016/679) και την Ελληνική Νομοθεσία και αποσκοπεί στο να σας ενημερώσει σχετικά με τις πληροφορίες που συλλέγονται κατά την επίσκεψή σας στον ιστότοπο του ΙΤΕ. </p>
                                    <p>
                                        Το ΙΤΕ μπορεί να τροποποιήσει την παρούσα πολιτική, οποτεδήποτε και χωρίς προειδοποίηση, ανακοινώνοντας οποιαδήποτε τέτοια τροποποίηση μέσω του ιστοτόπου του. Με την πλοήγηση και χρήση του ιστοτόπου του ΙΤΕ, οι επισκέπτες/χρήστες αναγνωρίζουν ότι έχουν διαβάσει, κατανοήσει και ανεπιφύλακτα αποδεχθεί την Πολιτική Προστασίας Δεδομένων. </p>

                                    <b>Υπεύθυνος φορέας </b>

                                    <p>Υπεύθυνος επεξεργασίας των δεδομένων προσωπικού χαρακτήρα για τις ανάγκες λειτουργίας του παρόντος ιστοτόπου είναι: <br/>
                                        <br/>

                                        ΙΔΡΥΜΑ ΤΕΧΝΟΛΟΓΙΑΣ ΚΑΙ ΕΡΕΥΝΑΣ (Ν.Π.Ι.Δ) <br/>
                                        Ν. Πλαστήρα 100 <br/>
                                        Βασιλικά Βουτών <br/>
                                        Τ.Κ. 700 13 <br/>
                                        ΗΡΑΚΛΕΙΟ ΚΡΗΤΗΣ <br/>
                                        <br/>

                                        Στους παρακάτω όρους θα βρείτε σημαντικές πληροφορίες όσον αφορά στο είδος, στο σκοπό της χρήσης των προσωπικών δεδομένων σας, την προστασία τους αλλά και τα δικαιώματά σας ως υποκείμενα των δεδομένων αυτών. </p>
                                    <p>
                                        Για οποιαδήποτε διευκρίνιση μπορείτε να επικοινωνήσετε με τον Υπεύθυνο Προστασίας Προσωπικών Δεδομένων του ΙΤΕ στο <a  target="_blank"  href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>. </p>

                                    <b>Προσωπικά δεδομένα που συλλέγει ο Ιστότοπος του ΙΤΕ </b>

                                    <p>Κατά την επίσκεψή σας στον ιστότοπό μας δεν είστε υποχρεωμένοι να μας παρέχετε προσωπικές σας πληροφορίες. Η μοναδική περίπτωση όπου σας ζητούμε προσωπικά σας στοιχεία είναι όταν εσείς οι ίδιοι θέλετε να επικοινωνήσετε μαζί μας συμπληρώνοντας την ηλεκτρονική φόρμα επικοινωνίας που διαθέτουμε στον ιστότοπό μας. Στην περίπτωση αυτή σας ζητούμε τα παρακάτω στοιχεία:</p>
                                    <p>

                                        - Ονοματεπώνυμο<br/>
                                        - Ιδιότητα<br/>
                                        - Εταιρεία ή οργανισμός στον οποίο υπάγεστε<br/>
                                        - Διεύθυνση ηλεκτρονικού ταχυδρομείου (email)<br/>
                                        - Ταχυδρομική διεύθυνση<br/>
                                        - Αριθμός τηλεφώνουv<br/>
                                    </p>
                                    <p>
                                        εκ των οποίων υποχρεούστε να συμπληρώσετε μόνο το ονοματεπώνυμο, την εταιρεία/οργανισμό και τη διεύθυνση ηλεκτρονικού ταχυδρομείου (email) .
                                        Κατά την επίσκεψή σας στον ιστότοπό μας ενδέχεται να συλλεγούν αυτομάτως πληροφορίες όπως η IP διεύθυνσή (διεύθυνση διαδικτυακού πρωτοκόλλου) του υπολογιστή σας.</p>
                                    <p>

                                        Για περισσότερες πληροφορίες μπορείτε να δείτε τη σχετική πολιτική του ΙΤΕ για τη χρήση cookies παρακάτω ή στους ΄Ορους Χρήσης.</p>
                                    <p>

                                        Ο οργανισμός μας διαθέτει σελίδα σε πλατφόρμες κοινωνικής δικτύωσης όπως το Facebook, το TWITTER, το LINKEDIN, και το YOUTUBE, όπου όμως δεν πραγματοποιεί καμία επεξεργασία προσωπικών δεδομένων. Υπάρχει η δυνατότητα επικοινωνίας με τους διαχειριστές της εκάστοτε σελίδας του ΙΤΕ μέσω αποστολής μηνύματος. Στην περίπτωση που ο διαχειριστής της εκάστοτε σελίδας λάβει μηνύματα που εμπεριέχουν προσωπικά δεδομένα φυσικών προσώπων, αυτά είναι απολύτως εμπιστευτικά και η χρήση τους εξυπηρετεί αποκλειστικά το λόγο της επικοινωνίας με το Ίδρυμα και μετά την εκπλήρωση του σκοπού για τον οποίο έχουν συλλεχθεί διαγράφονται.</p>
                                    <p>

                                        Το ΙΤΕ δεν ασκεί και δεν μπορεί να ασκεί επιρροή και έλεγχο όσον αφορά την φύση και την έκταση των προσωπικών δεδομένων που συλλέγονται και τηρούνται από τις πλατφόρμες κοινωνικής δικτύωσης ως όρος ή αποτέλεσμα της χρήσης τους και δεν φέρει καμία ευθύνη για τη συλλογή και επεξεργασία προσωπικών δεδομένων που πραγματοποιείται από αυτές. Για περισσότερες πληροφορίες σχετικά με τους σκοπούς της συλλογής και την περαιτέρω επεξεργασία και χρήση των προσωπικών δεδομένων από τις πλατφόρμες κοινωνικής δικτύωσης καθώς και για τα δικαιώματα και τις διαθέσιμες ρυθμίσεις για την προστασία της ιδιωτικότητάς σας και των προσωπικών δεδομένων σας, συμβουλευτείτε την πολιτική προστασίας προσωπικών δεδομένων της εκάστοτε πλατφόρμας κοινωνικής δικτύωσης.</p>

                                    <b>Σκοπός και αρχές της συλλογής δεδομένων προσωπικού χαρακτήρα</b>

                                    <p>Το ΙΤΕ συλλέγει και επεξεργάζεται τα προσωπικά δεδομένα των επισκεπτών/ χρηστών αποκλειστικά και μόνο στο πλαίσιο της εκπλήρωσης των σκοπών και λειτουργιών του και ακριβέστερα για την εξυπηρέτηση της επικοινωνίας μαζί σας. Η επεξεργασία περιορίζεται στα δεδομένα προσωπικού χαρακτήρα που είναι απαραίτητα και κατάλληλα για την εκπλήρωση των σκοπών και λειτουργιών του κόμβου. Η επεξεργασία υπόκειται στους κανόνες του Γενικού Κανονισμού Προστασίας Δεδομένων και του συναφούς Eνωσιακού δικαίου, της ελληνικής νομοθεσίας και των σχετικών διεθνών συνθηκών και συμβάσεων.</p>

                                    <b>Χρήση των προσωπικών δεδομένων που συλλέγουμε</b>

                                    <p>Τα προσωπικά δεδομένα που συλλέγουμε από την πλατφόρμα επικοινωνίας που διαθέτουμε στον ιστότοπό μας καθώς επίσης και όποια άλλα στοιχεία ενδέχεται να μας αποσταλούν μέσω των προφιλ που διαθέτουμε στα διάφορα συστήματα κοινωνικής δικτύωσης, χρησιμοποιούνται μονάχα για τις ανάγκες της επικοινωνίας μαζί σας και για την καλύτερη εξυπηρέτησή σας. Τα cookies, κατά την πλοήγηση στον ιστότοπο, χρησιμοποιούνται μόνο για την ανάλυση της επισκεψιμότητας του ιστοτόπου μας. Ουδεμία περαιτέρω επεξεργασία, προώθηση ή ανταλλαγή γίνεται στα δεδομένα αυτά. Σε κάθε περίπτωση, για την ως άνω χρήση των προσωπικών σας δεδομένων, ζητείται προηγουμένως από εσάς η σχετική συγκατάθεση.</p>

                                    <b>Πολιτική για Cookies</b>

                                    <p>Κατά την πλοήγηση στον παρόντα ιστότοπο, το ΙΤΕ ενδέχεται να συγκεντρώνει στοιχεία αναγνώρισης των χρηστών χρησιμοποιώντας αντίστοιχες τεχνολογίες, όπως cookies ή/και την παρακολούθηση διευθύνσεων Πρωτοκόλλου Internet (IP). Τα cookies είναι μικρά τμήματα κειμένου που αποστέλλονται στο πρόγραμμα περιήγησης από έναν ιστότοπο που επισκέπτεται ο χρήστης. Η χρήση των cookies διευκολύνει τον ιστότοπο να απομνημονεύει πληροφορίες σχετικά με την επίσκεψη του χρήστη, όπως π.χ την προτιμώμενη γλώσσα σας, την απομνημόνευση των προτιμήσεών σας, όσον αφορά στην ασφαλή αναζήτηση, τον υπολογισμό του αριθμού των επισκεπτών ή τη διευκόλυνση της εγγραφής στις υπηρεσίες μας.<br/>

                                        <b>Πώς να ελέγχετε τα cookies:</b> Μπορείτε να ελέγχετε και/ή να διαγράφετε τα cookies ανάλογα με τις επιθυμίες σας. Λεπτομέρειες θα βρείτε εδώ: aboutcookies.org. Μπορείτε να διαγράψετε όλα τα cookies που βρίσκονται ήδη στον υπολογιστή σας, όπως και να ρυθμίσετε τους περισσότερους φυλλομετρητές κατά τρόπο που να μην επιτρέπουν την εγκατάσταση cookies. Ωστόσο, στην περίπτωση αυτή, ίσως χρειαστεί να προσαρμόζετε εσείς από μόνοι σας ορισμένες προτιμήσεις κάθε φορά που επισκέπτεστε έναν ιστότοπο. Ο χρήστης δύναται να κάνει χρήση του ιστοτόπου χωρίς προβλήματα και χωρίς τη χρήση των cookies αλλά ενδεχομένως εις βάρος της ευχρηστίας του και της λειτουργίας ορισμένων υπηρεσιών αυτού.
                                        Τυχόν προσωπικά δεδομένα που συλλέγονται μέσω cookies και μπορούν να συσχετιστούν με συγκεκριμένο επισκέπτη/χρήστη αποτελούν αντικείμενο επεξεργασίας αποκλειστικά για τους σκοπούς που αναφέρθηκαν παραπάνω.</p>

                                    <b>Για το newsletter του ΙΤΕ</b>

                                    <p>Στο κοινωνικό δίκτυο του FACEBOOK έχει δημιουργηθεί σελίδα για την εγγραφή στο newsletter του ΙΤΕ (<a  target="_blank"  href="https://www.facebook.com/ITE.HELLAS/app/100265896690345/">https://www.facebook.com/ITE.HELLAS/app/100265896690345/</a>). Για τον σκοπό της διάδοσης και αποστολής του newsletter ζητείται και καταχωρίζεται το ονοματεπώνυμο και η ηλεκτρονική διεύθυνση του χρήστη που εκδηλώνει ενδιαφέρον για τη λήψη του newsletter. Ο ενδιαφερόμενος μπορεί να απεγγραφεί από τη λίστα των αποδεκτών του newsletter όποτε το επιθυμεί και τα δεδομένα που έχουν καταχωριστεί για τον ως άνω σκοπό διαγράφονται.</p>

                                    <b>Διαβίβαση/Κοινοποίηση δεδομένων σε τρίτα μέρη</b>

                                    <p>Τα προσωπικά δεδομένα που συλλέγονται ενδέχεται να κοινοποιούνται ή διαβιβάζονται σε τρίτους, εφόσον αυτό επιβάλλεται για την εκπλήρωση υποχρεώσεων από το νόμο ή είναι αναγκαίο για την εκπλήρωση των σκοπών και λειτουργιών του ιστοτόπου, τηρουμένων των εγγυήσεων της οικείας νομοθεσίας. Ενδέχεται να αναθέτουμε σε φυσικά ή νομικά πρόσωπα τη διεκπεραίωση ορισμένων υπηρεσιών και λειτουργιών του ιστοτόπου. Σε αυτά τα πρόσωπα διαβιβάζονται μόνο εκείνα τα προσωπικά δεδομένα που είναι απαραίτητα για την εκπλήρωση των ανατεθειμένων υπηρεσιών και δεσμεύονται έναντι του ΙΤΕ ως προς την εμπιστευτικότητα και την ασφαλή επεξεργασία των προσωπικών δεδομένων.</p>

                                    <b>Τα δικαιώματά σας σε σχέση με την επεξεργασία δεδομένων που σας αφορούν</b>

                                    <p>Σύμφωνα με τις διατάξεις του Γενικού Κανονισμού περί Προστασίας Δεδομένων 679/2016/ΕΕ, έχετε δικαίωμα τόσο κατά τη φάση της συλλογής όσο και μεταγενέστερα να ενημερώνεστε για την τυχόν επεξεργασία των δεδομένων που σας αφορούν, τον σκοπό αυτής καθώς και την κοινοποίηση/διαβίβαση σε τρίτους και την ταυτότητα αυτών (δικαίωμα ενημέρωσης και πρόσβασης). Επίσης έχετε δικαίωμα να ζητήσετε τη διόρθωση, επικαιροποίηση ή και διαγραφή τν προσωπικών δεδομένων σας που τηρεί το ΙΤΕ. Έχετε επίσης το δικαίωμα περιορισμού της επεξεργασίας και δικαίωμα εναντίωσης.
                                        Για την ενημέρωσή σας και την άσκηση των δικαιωμάτων σας μπορείτε να επικοινωνείτε με τον Υπεύθυνο Προστασίας Προσωπικών Δεδομένων στο <a href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.
                                    </p>
                                    <p>
                                        Σας επισημαίνουμε ότι σύμφωνα με τον Κανονισμό έχετε δικαίωμα υποβολής καταγγελίας στην Αρχή Προστασίας Δεδομένων Προσωπικού Χαρακτήρα.</p>

                                    <b>Εμπιστευτικότητα και ασφάλεια</b>

                                    <p>Τα προσωπικά δεδομένα που συλλέγουμε στο πλαίσιο της λειτουργίας του ιστοτόπου είναι τα απολύτως απαραίτητα για τους σκοπούς της επικοινωνίας μαζί σας. Είναι απολύτως εμπιστευτικά και τηρούνται μόνο για τις ανάγκες αυτής της επικοινωνίας. Πρόσβαση σε αυτά τα δεδομένα έχουν ελάχιστα στελέχη του οργανισμού, τα οποία έχουν δεσμευθεί για την τήρηση εχεμύθειας. Επιπλέον, διαθέτουμε επαρκή συστήματα ασφαλείας και λαμβάνουμε όλα τα αναγκαία και κατάλληλα οργανωτικά και τεχνικά μέτρα προκειμένου να αποφευχθεί τυχόν παραβίαση της ασφάλειας των προσωπικών δεδομένων (διαρροή, αποκάλυψη, πρόσβαση από μη δικαιούμενα πρόσωπα) από τα συστήματά μας.</p>

                                    <b>Τροποποίηση της παρούσας πολιτικής προστασίας προσωπικών δεδομένων</b>

                                    <p>Η παρούσα πολιτική προστασίας προσωπικών δεδομένων ενδέχεται να αλλάξει όποτε αυτό απαιτείται και πάντοτε ακολουθώντας το εθνικό και Ευρωπαϊκό δίκαιο. Για το λόγο αυτό, καλείστε ανά τακτά χρονικά διαστήματα να επισκέπτεστε την παρούσα σελίδα προς τη δική σας ενημέρωση. Με την πλοήγηση και χρήση ιστοτόπου του ΙΤΕ, οι επισκέπτες/χρήστες αναγνωρίζουν ότι έχουν διαβάσει, κατανοήσει και ανεπιφύλακτα αποδεχθεί την Πολιτική Προστασίας Δεδομένων.</p>

                                    <b>Επικοινωνία</b>

                                    <p>Για οποιοδήποτε ερώτημα προκύψει αναφορικά με την παρούσα πολιτική προστασίας προσωπικών δεδομένων ή εάν πιστεύετε ότι υπάρχουν ασάφειες και ασυμβατότητα με την παρούσα πολιτική από τη μεριά μας, μπορείτε να το γνωστοποιήσετε στον Υπεύθυνο Προστασίας Προσωπικών δεδομένων του Ιδρύματος στο <a href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.</p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <b>PERSONAL DATA PROTECTION POLICY</b>

                                    <p>The Foundation for Research and Technology - Hellas (FORTH) pays special attention to the protection of the visitors’ and users’ privacy and personal data. Please note that personal data means, under the relevant legislation (General Data Protection Regulation, 2016/679/EU) only information that relates to an identified or – based on certain characteristics – identifiable natural person (data subject).
                                        Information relating to legal persons and groups of persons or statistical information which do not enable reduction to an identified or identifiable natural person do not fall within this category and are exempted from the scope of the relevant legislation.</p>
                                    <p>
                                        This personal data protection policy is fully consistent with the European Union Regulation on the protection of natural persons with regard to the processing of personal data (EU/2016/679) and Greek law and is aimed to provide information about the information collected during your visit at the website of FORTH.</p>
                                    <p>
                                        FORTH may modify this policy at any time, without previous notice, by announcing any such
                                        modification on its website. By navigating in and using the FORTH website, visitors/users acknowledge
                                        that they have read, understood and unconditionally accepted the Personal Data Protection Policy. </p>

                                    <b>Data Controller</b>

                                    <p>The personal data controller for the purpose of the operation of this website is as follows:<br/>
                                        <br/>
                                        FOUNDATION FOR RESEARCH AND TECHNOLOGY - HELLAS (FO.R.T.H.) <br/>
                                        (Research Organisation private law legal body) <br/>
                                        100 N. Plastira Str. <br/>
                                        Vassilika Vouton <br/>
                                        GR 700 13 <br/>
                                        HERAKLION, CRETE <br/>
                                        <br/>
                                        The following terms provide important information relating to the type, the purpose of use of your
                                        personal data, their protection, as well as your rights as subjects of these data.
                                        For any further explanation, you may contact the Data Protection Officer (DPO) of FORTH by sending an
                                        e-mail at <a  target="_blank"  href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>. </p>

                                    <b>Personal Data Collected by the FORTH Website</b>

                                    <p>During your visit to our website, you are not obliged to provide personal information. We only ask you
                                        to provide personal details when you want to contact us, by filling out the online contact form available
                                        on our website. In that case, we ask you to provide the following details:<br/>
                                        <br/>
                                        - Full name<br/>
                                        - Capacity<br/>
                                        - Company or organisation<br/>
                                        - E-mail address<br/>
                                        - Postal address<br/>
                                        - Telephone number<br/>
                                        <br/>
                                        of which it is only mandatory to fill out your full name, company/organisation and e-mail.
                                        During your visit at our website, certain information may be automatically collected, such as the IP
                                        address of your computer. </p>
                                    <p>
                                        For more information, please check the relevant cookies policy of FORTH below or the Terms of Use.</p>
                                    <p>
                                        Our organisation has pages on social media, such as on Facebook, TWITTER, LINKEDIN, and YOUTUBE,
                                        but no data processing is carried out on such web pages. You can contact the administrator of the
                                        relevant web page of FORTH by sending a message. If the administrator of the relevant page receives
                                        messages that contain personal data of natural persons, these shall be strictly confidential and their use
                                        shall exclusively serve the purpose of your communication with the Foundation and, when such purpose
                                        has been met, they shall be deleted.</p>
                                    <p>
                                        FORTH does not exercise and cannot exercise influence and control over the nature and extent of the
                                        personal data collected and kept by the social media as a condition or result of their use and may not be
                                        held liable for any collection and processing of personal data by them. For more information about the
                                        purpose of collection and the further processing and use of personal data by social media platforms, as
                                        well as about the rights and available arrangements for protecting your privacy and personal data,
                                        please check the personal data protection policy of the relevant social media.</p>

                                    <b>Purpose and Principles of Personal Data Collection</b>

                                    <p>FORTH collects and processes the personal data of visitors/users exclusively and only with a view to
                                        meeting its purposes and functions and, more specifically, for the purpose of its communication with
                                        you. Processing is limited to personal data that are necessary and appropriate for meeting the purpose
                                        and functions of the website. Processing is subject to the requirements of the General Data Protection
                                        Regulation and the relevant Union law, Greek legislation and international conventions and treaties.</p>

                                    <b>Use of the Personal Data Collected by Us</b>

                                    <p>The personal data we collect from the contact platform available on our website, as well as any other
                                        data that may be sent to us through our profiles on the various social networks, shall be used only for
                                        the needs of our communication with you and for your better service. While navigating on our website,
                                        cookies are used only for the purpose of statistical analysis of the visits to our website. No further
                                        processing, transmission or exchange of these data shall take place. In any event, you are a priori
                                        requested to consent to the above use of your personal data. </p>

                                    <b>Cookies Policy</b>

                                    <p>During users’ navigation on this website, FORTH may collect identification data of users, by using
                                        relevant technologies, such as cookies and/or Internet Protocol (IP) address monitoring. Cookies are
                                        small text segments that are sent to the browser by a website visited by the user. The use of cookies
                                        helps the website to remember information about the user’s visit, such as your preferred language and
                                        your preferences, to make secure searches, to calculate the number of visitors, or to facilitate your
                                        registration in our services.</p>
                                    <p>
                                        <b>How to control cookies:</b>
                                        You may control and/or delete cookies as you wish. You may find more details at aboutcookies.org. You may delete all cookies from your computer and, in most browsers, select settings that do not allow installation of cookies. However, in that case, you may have to adjust certain preferences every time you visit a website. Users may make use of the website without problems even without use of cookies, but, potentially, to the detriment of its user-friendliness and of the functioning of certain of its services.
                                        Any personal data collected via cookies that can be correlated to a specific visitor/user shall be processed exclusively for the purposes cited above.
                                    </p>

                                    <b>For the Newsletter issued by FORTH</b>

                                    <p>A page has been created on FACEBOOK for subscription to the newsletter issued by FORTH
                                        (<a target="_blank" href="https://www.facebook.com/ITE.HELLAS/app/100265896690345/">https://www.facebook.com/ITE.HELLAS/app/100265896690345/</a>). For the purpose of disseminating
                                        and sending the newsletter, users expressing an interest in receiving the newsletter are asked to provide
                                        their full name and email address. The persons concerned may have their name removed from the list of
                                        recipients of the newsletter at any time and the data registered for the above purpose shall be deleted.</p>

                                    <b>Data Transmission/Disclosure to Third Parties</b>

                                    <p>The personal data collected may be disclosed or transmitted to third parties, if this is mandatory for
                                        fulfilling legal obligations or necessary for meeting the purposes and functions of the website, subject to
                                        the safeguards provided for by relevant legislation. We may assign to natural or legal persons the task of
                                        performing certain services and functions of the website. Those persons shall receive only personal data
                                        that are necessary for performing the services assigned and are bound by FORTH to the confidentiality
                                        and safe processing of the personal data.</p>

                                    <b>Your Rights Relating to the Processing of Your Data</b>

                                    <p>In accordance with the provisions of the General Data Protection Regulation (679/2016/EU), you have
                                        the right, both during the collection and afterwards, to be informed about any processing of your
                                        personal data, its purpose, as well as the disclosure/transmission to third parties and their identity (right
                                        of information and access). You have also the right to request that your personal data kept by FORTH be
                                        corrected, updated or deleted. You have also the right to have the processing restricted and the right to
                                        object.</p>
                                    <p>
                                        In order to receive information and exercise your rights, you may contact the Personal Data Officer at
                                        <a target="_blank"  href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.</p>
                                    <p>
                                        We point out that, in accordance with the Regulation, you have the right to file a complaint to the Data
                                        Protection Authority.</p>

                                    <b>Confidentiality and Security</b>

                                    <p>The personal data we collect within the context of the operation of the website are those strictly
                                        necessary for the purpose of our communication with you. They are strictly confidential and are kept
                                        only for the needs of such communication. Access to these data is provided to very few officers of the
                                        organisation, who have been bound to keeping confidentiality. Moreover, we have adequate security
                                        systems and take all necessary and appropriate organisational and technical measures in order to
                                        prevent any breach of personal data security (leak, disclosure, unauthorised access) in our systems.</p> 

                                    <b>Modification to this Personal Data Protection Policy</b>

                                    <p>This personal data protection policy may change whenever necessary, always in compliance with
                                        national and Union law. For that reason, you are kindly requested to visit this page regularly in order to
                                        be informed. By navigating on and using the FORTH website, visitors/users acknowledge that they have
                                        read, understood and unconditionally accepted the Personal Data Protection Policy.</p>

                                    <b>Contact</b>

                                    <p>If you have any questions relating to this personal data protection policy or if you believe that there is
                                        any vagueness or incompatibility in our personal data protection policy, you may communicate such
                                        instance to the Data Protection Officer (DPO) of FORTH by sending an e-mail at <a  target="_blank"  href="mailto:dpo@admin.forth.gr">dpo@admin.forth.gr</a>.</p>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
        </div>

    </xsl:template>

</xsl:stylesheet>
