# Support Vector Machines

> In machine learning, support vector machines are supervised learning models with associated learning algorithms 
that analyze data used for classification and regression analysis. Mostly are being used in **classification problems**

## Lineárne dáta
Základy fungovania SVM je možné pochopiť týmto jednoduchým príkladom.
Predstavme si že máme
- dva tagy: **červený** a **modrý**
- a definované dáta sú na dvoch osách: **x** a **y**

Chceme nájsť *jednoznačný* classifier, kt. na základe x,y súradníc určí či je výsledok červený alebo modrý
![alt text](http://res.cloudinary.com/dyd911kmh/image/upload/f_auto,q_auto:best/v1532721365/Fig1_enqvf6.png)

SVM zoberie dátové body a vyznačí tzv. *hyperplane* (v 2D svete je to čiara), kt. najlepšie rozdeľuje tagy.
Táto čiara je rozhodujúca hranica:
- všetko, čo padne na jej JEDNU stranu sa klasifikuje ako **MODRÉ**
- všetko, čo padne na jej DRUHÚ stranu sa klasifikuje ako **ČERVENÉ**

![alt text](http://res.cloudinary.com/dyd911kmh/image/upload/f_auto,q_auto:best/v1532721364/Fig2_sorgp6.png)

Potom tu nastáva otázka že kt. hyperplane/čiara je najlešia?
- pre SVM je to tá, kt. maximalizuje marginy z obidvoch tagov
- resp. hyperplane kt. vzdialenosť k najbližšiemu prvku každého tagu je najväčšia

![alt text](http://res.cloudinary.com/dyd911kmh/image/upload/f_auto,q_auto:best/v1532721364/Fig3_akmlzb.png)

# Výsledky
![alt text](https://github.com/absolutty/r.SupportVectorMachines/blob/master/exported/images/test-set.png "Test set image.")
![alt text](https://github.com/absolutty/r.SupportVectorMachines/blob/master/exported/images/train-set.png "Train set image.")