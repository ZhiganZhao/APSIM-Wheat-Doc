# Leaf {#cha:leaf}





Leaf cohort model is used in the APSIM-Wheat.



## Life growth cycle {#sec:leaf-growth-cycle}

The growth cycle of leaf cohort is divided into 7 stages and 6 periods from `Initialized` to `Detached`. The length of each period depends on the `plastrochron` and `phylochron` for initialization and appearance and is configured by `CohortParameters` for others.

Several status variables are defined for each leaf cohort, which can be used in other modules to describe the current status of leaf cohort, i.e. `IsNotAppeared`, `IsGrowing`, `IsAlive`, `IsGreen`, `IsNotSenescing`, `Senescing`, `isFullyExpanded`, `ShouldBeDead`, `IsAppeared` and `IsInitialised`. 

<div class="fig-input">
<div class="figure" style="text-align: center">
<!--html_preserve--><div id="htmlwidget-f28f38c6712e818fe69c" style="width:95%;height:470.4px;" class="DiagrammeR html-widget"></div>
<script type="application/json" data-for="htmlwidget-f28f38c6712e818fe69c">{"x":{"diagram":"sequenceDiagram;\n\tInitialized->>Appeared: Appearance \n\tAppeared->>Expanded: GrowthDuration\n\tExpanded->>Senescing: LagDuration\n\tSenescing->>Senesced: SenescenceDuration\n\tSenesced->>Detaching: DetachmentLagDuration\n\tDetaching->>Detached: DetachmentDuration\n    Initialized->Appeared: IsNotAppeared\n    Initialized->Expanded: IsGrowing\n\tInitialized->>Senesced: IsAlive\n\tInitialized->>Senesced: IsGreen\n\tInitialized->>Senescing: IsNotSenescing\n\tSenescing->>Senesced: IsSenescing\n\tExpanded->>Detached: IsFullyExpanded\n\tSenesced->>Detached: ShouldBeDead\n\tSenesced->>Detached: Finished\n\tAppeared->>Detached: IsAppeared\n\tInitialized->>Detached: IsInitialised\n"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
<p class="caption">(\#fig:leaf-life-cycle)The life cycle of a leaf cohort.</p>
</div>
</div>



### leaf age

The age of leaf cohort is defined as the thermal time after appearance, (i.e. keep zero after initialization). As the default values of `DetachmentLagDuration` and `DetachmentDuration` are set as `1000000` <sup>&deg;</sup>Cd, the cohort age keeps increasing until growth stage `ReadyForHarvesting`. The age of first leaf cohort starts from  200 <sup>&deg;</sup>Cd.


### Leaf initialization and appearance

At `Germination`, 2 new leaf cohorts are initialized with initial leaf area 200, 0 mm^2^. The inital leaf area simulates seed biomass or embryo size. 

At `Emergence` stage, 1 leaf cohort is appeared at the main stem, and 1 new leaf cohort is initialized. 

Before plant reaches the final leaf number (i.e. all leaves are initialized and appeared), a new leaf cohort is initialized and appeared when increases of potential appearance of tip number are more than 1 (Figure \@ref(fig:str-delta-tip)). Consequently, the rates of leaf initialization and appearance are same, except initialized tip number is more than 2  of appeared tip number (Fig. \@ref(fig:leaf-cohort-number)).

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-cohort-number-1.png" alt="The initialized and appeared leaf cohort number in the main stem" width="80%" />
<p class="caption">(\#fig:leaf-cohort-number)The initialized and appeared leaf cohort number in the main stem</p>
</div>
</div>

<!-- 
### Growth duration

Leaf expansion of cohort $i$ starts from appearance of leaf tip $i$, i.e. the expansion of leaf cohort in the sheath is ignored which does not contribute to green leaf or leaf area index. The growth duration of spring wheat is close to one phylochron as the synchronization of leaf blade and sheath   [@SkinnerElongationGrassLeaf1995].

As the variation of phyllochron (Fig. \@ref(fig:sec:str-phyllochron)), the growth duration also changes by cohort rank. The growth duration of flag leaf is shorter than secondary leaf as the fraction of flag leaf (Fig. \@ref(fig:final-leaf-fraction).

<div class="fig-output">

</div>


### Lag duration 

Lag duration (full functional duration) is defined as 4 phyllochrons for leaf appeared during vegetative period (from emergence to terminal spikelet). For leaf cohort appeared during stem elongation period (from terminal spikelet to flag leaf), the lag duration equals to total length from stage `FlagLeaf` to stage `EndGrainFill` minus 3 phyllochron (`senescence duration`), i.e. flag leaf is completely death at the stage `EndGrainFill`. 


<div class="fig-output">

</div>

### Senescene and detachment duration

Senescence duration is defined as 3 phyllochrons. Detachment lag and detachment duration are set as a big value `1000000` which assumes no detachment in wheat. Actually all leaves are detached at `Harvesting` event. 

Figure \@ref(fig:leaf-cohort-number) shows the number of leaf cohort for expanding, initialized, appeared, senescing and dead cohort.



<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-cohort-no-1.png" alt="The number of leaf cohort with certain status including initialised, appeared, expanded, green, dead" width="80%" />
<p class="caption">(\#fig:leaf-cohort-no)The number of leaf cohort with certain status including initialised, appeared, expanded, green, dead</p>
</div>
</div>

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-cohort-changing-no-1.png" alt="The number of leaf cohort with certain status including expanding and senescing" width="80%" />
<p class="caption">(\#fig:leaf-cohort-changing-no)The number of leaf cohort with certain status including expanding and senescing</p>
</div>
</div>

### Drought stress on leaf development

After appearance, leaf development is accelerated by the drought stress through increasing the daily thermal time, i.e. leaf age is accelerated by drought. The factor of acceleration depends on the ratio of water supply and demand (Figure \@ref(fig:water-supply-demand-ratio)). Daily thermal time is doubled when there is no water supply (i.e. Ratio of water supply and demand equals to zero), and no acceleration when ratio above 0.7 (The values in Figure \@ref(fig:leaf-development-drought) plus one).


<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-development-drought-1.png" alt="Drought stress accelerates leaf development. Daily thermal time is doubled when there is no water supply (i.e. Ratio of water supply and demand equals to zero), and no acceleration when ratio above 0.7." width="80%" />
<p class="caption">(\#fig:leaf-development-drought)Drought stress accelerates leaf development. Daily thermal time is doubled when there is no water supply (i.e. Ratio of water supply and demand equals to zero), and no acceleration when ratio above 0.7.</p>
</div>
</div>


```csharp
//Acellerate thermal time accumulation if crop is water stressed.
double _ThermalTime;
if ((LeafCohortParameters.DroughtInducedSenAcceleration != null) && (IsFullyExpanded))
    _ThermalTime = TT * LeafCohortParameters.DroughtInducedSenAcceleration.Value;
else _ThermalTime = TT;

```


## Cohort population

Cohort population is initialized as the total stem population at appearance of leaf cohort, and proportionally reduced by plant and stem mortalities (\@ref(#sec-structure-mortality)) at each day after appearance.

<div class='fig-output'>

</div>

The total leaf number is multiplied by leaf cohort number and stem number (Figure \@ref(fig:leaf-number)).

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-number-1.png" alt="Appeared number of green, senesced and total leaves" width="80%" />
<p class="caption">(\#fig:leaf-number)Appeared number of green, senesced and total leaves</p>
</div>
</div>



<div class="rmdimportant">
<p>The tiller death is detached from plants, but leaf death isn't detached.</p>
</div>


The fraction of final leaf is set as 1, but return the actual fraction of the final leaf if the last leaf has appeared. 

<div class="fig-output">

</div>



## Development of leaf size

During the growth duration of each cohort, the daily increase of leaf area is detemined by the minimum increase of water ($\Delta A_{water}$) and carbon ($\Delta A_{carbon}$) constrained leaf area. 


### Maximum (potential) leaf area

The maximum leaf area of each leaf cohort is determined by potential maximum leaf area and reduced by cell division stress and final leaf fraction when leaf cohort is appeared. 


The potential maximum leaf areas by rank are specified by two parameters the maximum leaf area in all leaves (`AreaLargestLeaves` with default value 2600 mm^2^) and an age factor (Figure \@ref(fig:maximum-area-age)). The age factor is assumed leaf areas are linearly increasing from stage `Emergence` to `Terminal spikelet`, and all leaves appeared after stage `Terminal Spikelet` have the same maximum leaf area (the last three leaves in the current configuration of plastochron and phyllochron, Figure \@ref(fig:node-number)).

<div class="rmbimportant">
<p>The function of maximum leaf size is proposed to change. Documentation needs to update.</p>
</div>


<div class="fig-input">

</div>



The stress factor of cell division is determined by water (Figure \@ref(fig:water-supply-demand-ratio)) and nitrogen stresses (Figure \@ref(fig:nitrogen-functional-nitrogen)). Stress of cell division is averaged by cell division stress factors from initialization to appearance.

In the test simulation, the maximum leaf areas are increasing from Rank 1 to Rank 9, then decreasing to flag leaf (Figure \@ref(fig:leaf-cohort-max-area)), which is caused by nitrogen stress after terminal spikelet (Figure \@ref(fig:nitrogen-functional-nitrogen)). 

<div class="fig-output">

</div>



### Potential expansion of leaf cohort

The potential leaf area is calculated by a logistic equation as a function of thermal time after leaf appearance. The shape of logistic equation is determiend by parameter `LeafSizeShapeParameter` with default value `0.3` (Fig. \@ref(fig:size-function)). 

<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/size-function-1.png" alt="The size function of leaf area development" width="80%" />
<p class="caption">(\#fig:size-function)The size function of leaf area development</p>
</div>



### Water constrained leaf area

The potential increase of leaf area is reduced by `ExpansionStress` with default value 1



### Carbon constrained leaf area

<div class="fig-output">

</div>




<div class="fig-output">

</div>


Not sure about the meaning of leaf size?

<div class="fig-output">

</div>





Leaf area index (LAI) are calculated for green leaf ($\text{LAI}_{g}$), dead leaf ($\text{LAI}_{d}$), and total leaf ($\text{LAI}_{t}$). 


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-lai-1.png" alt="Leaf area index" width="80%" />
<p class="caption">(\#fig:leaf-lai)Leaf area index</p>
</div>
</div>


### Leaf senescence

During the period of leaf senescene, the daily fraction of leaf senescence is linearly related with thermal time.


<div class="fig-output">

</div>



## Ground coverage

and coverage are calculated for green leaf ($C_g$), dead leaf ($C_d$), and total leaf ($C_t$) from LAI and extinction coefficient for green leaf ($k_{g}$) and dead leaf ($k_{d}$). 

$$
C_{g}=C_{max}(1-\exp(-k_{g}\frac{\text{LAI}_{g}}{C_{max}}))
$$

As the default value of maximum coverage ($C_{max}$) is 1, the function is reduced to
$$
C_{g}=1-\exp(-k_{g}\text{LAI}_{g})
$$

The similar equation is used for dead coverage.

$$
C_{d}=1-\exp(-k_{d}\text{LAI}_{d})
$$

Total coverage ($C_t$) is calculated from coverage of green and dead leaves.
$$
    C_{t} = 1 - (1 - C_{g})(1 - C_{d})
$$

The extinction coefficient for dead leaf ($k_{d}$) is defined as 0.3. The extinction coefficient for green leaf ($k_{g}$) is calculated by parameter `ExtinctionCoeff` which is depending on LAI and water stress.  

In the current version of APSIM-Wheat, extinction coefficient is set as 0.5 without variation as leaf area index. 

<div class="rmdnote">
<p>Extinction coefficient of dead leaf (<span class="math inline"><em>k</em><sub><em>d</em></sub></span>) is not setable in the APSIM User Interface which is defined in the xml file.</p>
</div>


<div class="fig-input">

</div>

The extinction coefficient of green leaf is adjusted by water stress which is the ratio of water supply and demand. No adjustment is applied to extinction coefficient if water supply is more than water demand. However, extinction coefficient is reduced when water supply is less than water demand (Figure \@ref(fig:k-water-stress), i.e. $k$ = 0.25 when no water supply).

<div class="fig-input">

</div>






<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-cover-1.png" alt="Coverage" width="80%" />
<p class="caption">(\#fig:leaf-cover)Coverage</p>
</div>
</div>





## Biomass supply

## Biomass demand

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-biomass-1.png" alt="Leaf biomass" width="80%" />
<p class="caption">(\#fig:leaf-biomass)Leaf biomass</p>
</div>
</div>



<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-specific-leaf-area-1.png" alt="Specific leaf area" width="80%" />
<p class="caption">(\#fig:leaf-specific-leaf-area)Specific leaf area</p>
</div>
</div>


<div class="fig-output">

</div>

<div class="rmdwarning">
<p>Why does specific leaf area of flag leaf decrease after a few days of appearance.</p>
</div>


## Frost impact 

Kill a fraction in all leaves ...


## Biomass supply (Photosynthesis)

The daily biomass accumulation ($\Delta Q$) corresponds to dry-matter above-ground biomass, and is calculated as a potential biomass accumulation resulting from radiation interception ($\Delta Q_{r}$) that is limited by soil water deficiency ($\Delta Q_{w}$).

### Potential biomass accumulation from radiation use efficiency

The radiation-limited dry-biomass accumulation ($\Delta Q_{r}$) is calculated by the intercepted radiation ($I$), radiation use efficiency ($RUE$).

$$
\Delta Q_{r}=I \times RUE
$$

#### Radiation interception

Radiation interception is calculated from the leaf area index (LAI, m$^{2}$ m$^{-2}$) and the extinction coefficient (*k*) [@MonsiFactorLightPlant2005]. 
$$
I=I_{0}(1-\exp(-k\times LAI)
$$


where $I_{0}$ is the total radiation at the top of the canopy (MJ) which is directly imported from weather records. Extinction coefficient ($k$) set as a constant value 0.5 in current version of APSIM.

#### Actual radiation use efficiency

The actual $RUE$ (g MJ$^{\text{-1}}$) is calculated as the potential $RUE$ ($RUE_p$) and several reduction factors, including plant nutrition ($F_{n,\ photo}$), air temperature($F_{t,\ photo}$), vapour pressure deficit ($F_{vpd}$), water supply ($F_w$) and atmospheric CO2 concentration ($F_{co2}$).

\begin{equation}
RUE = RUE_p \times \min{(F_{t,\ photo}, F_{n,\ photo}, F_{VPD})} \times F_W \times F_{CO2}
\end{equation}

*The potential RUE ($RUE_p$)* has a default value 1.5 in the current version of APSIM.

*The temperature factor ($F_t$)* is calculated as a function of average daily temperature weighted toward maximum temperature according to the specified `MaximumTemperatureWeighting` factor ($W_{maxt}$) with default value 0.75 (reference).


$$F_{t,\ photo}=h_{t,\ photo}[W_{maxt}T_{max}+(1-W_{maxt})T_{min}]$$


<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/biomass-ft-1.png" alt="The temperature factor which influences radiation use efficiency" width="80%" />
<p class="caption">(\#fig:biomass-ft)The temperature factor which influences radiation use efficiency</p>
</div>
</div>


*The plant nutrition factor* $f_{n,\,photo}$ is determined by the difference between leaf nitrogen concentration and leaf minimum and critical nitrogen concentration.

$$
f_{N,\,photo}=R_{N,\,photo}\sum_{leaf}\frac{C_{N}-C_{N,\,min}}{C_{N,\,crit}-C_{N,\,min}}
$$


where $C_{N}$ is the nitrogen concentration of `Leaf` parts; $R_{N,\,expan}$ is multiplier for nitrogen deficit effect on phenology which is specified by `N_fact_photo` in the wheat.xml and default value is 1.5.


<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/biomass-fn-1.png" alt="The nitrogen factor which influences radiation use efficiency" width="80%" />
<p class="caption">(\#fig:biomass-fn)The nitrogen factor which influences radiation use efficiency</p>
</div>
</div>

**Water stress factor**


For C3 plants (like wheat),  **The CO$_{\text{2}}$ factor** is calculated by a function of environmental CO$_{\text{2}}$ concentration ($C$, ppm; $C$ > 350 ppm) and daily mean temperature ($T_{mean}$ < 50&deg;C) as published by @ReyengaModellingglobalchange1999

$$
f_{c}=\frac{(C-C_{i})(350+2C_{i})}{(C+2C_{i})(350-C_{i})}
$$

where $C_{i}$ is the temperature dependent CO$_{\text{2}}$ compensation point (ppm) and is derived from the following function. 
$$
C_{i}=\frac{163-T_{mean}}{5-0.1T_{mean}}
$$



## Supply


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-supply-1.png" alt="Biomass supply from leaf" width="80%" />
<p class="caption">(\#fig:leaf-supply)Biomass supply from leaf</p>
</div>
</div>


## Demand


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-demand-1.png" alt="Biomass demand by leaf" width="80%" />
<p class="caption">(\#fig:leaf-demand)Biomass demand by leaf</p>
</div>
</div>

## Actual allocation

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-allocated-1.png" alt="Actual allocated biomass for leaf" width="80%" />
<p class="caption">(\#fig:leaf-allocated)Actual allocated biomass for leaf</p>
</div>
</div>


## Biomass dynamic

<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-live-1.png" alt="Dynamic of leaf biomass (Live component)" width="80%" />
<p class="caption">(\#fig:leaf-live)Dynamic of leaf biomass (Live component)</p>
</div>
</div>


<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-dead-1.png" alt="Dynamic of leaf biomass (Dead component)" width="80%" />
<p class="caption">(\#fig:leaf-dead)Dynamic of leaf biomass (Dead component)</p>
</div>
</div>





<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="leaf_files/figure-html/leaf-weight-1.png" alt="Dynamic of leaf biomass (Total)" width="80%" />
<p class="caption">(\#fig:leaf-weight)Dynamic of leaf biomass (Total)</p>
</div>
</div>


-->





