/* Mini projet CCAM - Samadou KODON
   Rapport pro automatisé - Candidature CPAM de Paris
*/

/* 1️⃣ Déclaration de la librairie */
libname ccam '/home/u59673186/sasuser.v94/PROJET CPAM';

/* 2️⃣ Variables pour l'heure de génération */
%let DateTime = %sysfunc(datetime(), datetime20.);

/* 3️⃣ Ouverture du rapport PDF */
ods escapechar='^';

ODS PDF file='/home/u59673186/sasuser.v94/PROJET CPAM/Projet_CCAM_Rapport.pdf'
    style=meadow /* style couleur et pro */
    notoc
    title="Mini projet CCAM - Rapport automatisé"
    author="Samadou KODON"
    startpage=now;

OPTIONS NODATE NONUMBER;

/* 4️⃣ Page de garde */
TITLE justify=CENTER "^S={preimage='/home/u59673186/sasuser.v94/PROJET CPAM/Logo.png' width=10cm}";
TITLE2 "Mini projet CCAM - Valorisation des données CCAM (2019-2023)";
TITLE3 "Rapport généré automatiquement le &DateTime";

/* 5️⃣ Introduction */
PROC ODSTEXT;
    p "Ce rapport présente une analyse exploratoire des données simulées d'actes médicaux (CCAM), réalisée sous SAS.";
    p " ";
    p "L'objectif est de démontrer ma capacité à produire des rapports automatisés, valorisant des indicateurs statistiques en appui aux travaux métier (révision de la nomenclature).";
    p " ";
    p "Les données simulées couvrent 3 spécialités sur la période 2021-2023.";
RUN;

/* 6️⃣ Import du fichier CSV */
proc import datafile='/home/u59673186/sasuser.v94/PROJET CPAM/Projet_CCAM_Simule.csv'
    out=ccam.data
    dbms=csv
    replace;
    getnames=yes;
    delimiter=',';
run;

/* 7️⃣ Préparation de la table de variation */
data ccam_2021_2023;
    set ccam.data;
    where Annee in (2021, 2023);
run;

proc sort data=ccam_2021_2023;
    by Specialite;
run;

proc transpose data=ccam_2021_2023 out=ccam_trans_volume prefix=Volume_;
    by Specialite;
    id Annee;
    var Volume_actes;
run;

data variation_volume;
    set ccam_trans_volume;
    Variation_pct_volume = ((Volume_2023 - Volume_2021) / Volume_2021) * 100;
run;

/* 8️⃣ Graphique - Evolution du volume d'actes */
PROC ODSTEXT;
    p "Evolution du volume d'actes CCAM par spécialité (2021-2023)";
RUN;

proc sgplot data=ccam.data;
    series x=Annee y=Volume_actes / group=Specialite markers lineattrs=(thickness=2);
    title "Evolution du volume d'actes CCAM par spécialité (2021-2023)";
    xaxis label="Année";
    yaxis label="Volume d'actes";
run;

/* 9️⃣ Commentaire - Volume d'actes */
PROC ODSTEXT;
    p "Analyse du graphique :";
    p " ";
    p "On observe une augmentation régulière du volume d'actes sur l'ensemble des spécialités.";
    p " ";
    p "La radiologie affiche la plus forte croissance relative, ce qui pourrait refléter un recours accru à l'imagerie médicale dans le parcours de soins.";
    p " ";
    p "Ce type de livrable pourrait être intégré directement dans le reporting métier pour appuyer les décisions de révision tarifaire.";
RUN;

/* 1️⃣0️⃣ Graphique - Evolution du tarif moyen */
PROC ODSTEXT;
    p "Evolution du tarif moyen par spécialité (2021-2023)";
RUN;

proc sgplot data=ccam.data;
    series x=Annee y=Tarif_moyen / group=Specialite markers lineattrs=(thickness=2);
    title "Evolution du tarif moyen par spécialité (2021-2023)";
    xaxis label="Année";
    yaxis label="Tarif moyen (€)";
run;

/* 1️⃣1️⃣ Commentaire - Tarif moyen */
PROC ODSTEXT;
    p "Analyse du graphique :";
    p " ";
    p "Hausse modérée des tarifs moyens sur l'ensemble des spécialités.";
    p " ";
    p "Cette évolution est cohérente avec les révisions tarifaires récentes de la nomenclature CCAM.";
    p " ";
    p "Ce type de suivi tarifaire automatisé pourrait enrichir les analyses fournies aux équipes en charge de la révision.";
RUN;

/* 1️⃣2️⃣ Table de variation % du volume d'actes */
PROC ODSTEXT;
    p "Variation % du volume d'actes entre 2021 et 2023";
RUN;

proc print data=variation_volume label noobs;
    var Specialite Volume_2021 Volume_2023 Variation_pct_volume;
    label 
        Volume_2021 = "Volume actes 2021"
        Volume_2023 = "Volume actes 2023"
        Variation_pct_volume = "Variation % 2021 → 2023";
    title "Table - Variation du volume d'actes CCAM (2021-2023)";
run;

/* 1️⃣3️⃣ Synthèse finale */
PROC ODSTEXT;
    p "Synthèse métier :";
    p " ";
    p "L'ensemble des spécialités étudiées présentent une augmentation d'activité entre 2021 et 2023, avec des dynamiques différenciées.";
    p " ";
    p "Ce type d'analyse permettrait d'alimenter les travaux de hiérarchisation de la nomenclature CCAM, en anticipant les impacts tarifaires et en identifiant les dynamiques spécifiques par spécialité.";
    p " ";
    p "Elle pourrait également contribuer à enrichir les outils de reporting et de pilotage à destination des équipes métier et partenaires institutionnels.";
RUN;

/* 1️⃣4️⃣ Footer professionnel */
footnote1 "Samadou KODON - Mini projet CCAM - Candidature Statisticien CPAM de Paris | GitHub : https://samadkod.github.io | Rapport généré le &DateTime";

/* 1️⃣5️⃣ Fermeture du rapport PDF */
ODS PDF CLOSE;
