# Phenology {#cha-phenology}




## Thermal time {#sec:phe-thermal-time}

The daily thermal time $\Delta TT$ is calculated using daily records of mean temperature ($T$) using a beta function [@WangSimulationphenologicaldevelopment1998]. 

$$
\Delta TT = T_{opt} \left\{\begin{matrix}
\frac{2 (T-T_{min})^{\alpha}(T_{opt} - T_{min})^\alpha-(T-T_{min}^{2\alpha})}{(T_{opt} - T_{min})^{2\alpha}} \quad \quad if \quad T_{min} \leqslant T \leqslant  T_{max}
\\
0 \quad \quad if \quad T < T_{min} \quad or \quad T>T_{max}
\end{matrix}\right.
$$
where, $T_{min}$, $T_{opt}$ and $T_{max}$ are the three cardinal temperatures for wheat development, which are 0, 27.5 and 40 ^o^C, respectively. The parameter $\alpha$ is calculated by the following equation. THe daily mean temperature $T$ is calculated as the average of daily minimum and maximum temperature.

$$
\alpha = \frac{\ln(2)}{\ln{\frac{(T_{max} - T_{min})}{T_{opt} - T_{min}}}}
$$

<div class="fig-input">
<div class="figure" style="text-align: center">
<img src="phenology_files/figure-html/phenology-beta-1.png" alt="Temperature response of wheat development" width="80%" />
<p class="caption">(\#fig:phenology-beta)Temperature response of wheat development</p>
</div>





<div class="fig-output">
<div class="figure" style="text-align: center">
<img src="phenology_files/figure-html/phenology-tt-1.png" alt="The daily thermal time calculated from the daily mean temperature" width="80%" />
<p class="caption">(\#fig:phenology-tt)The daily thermal time calculated from the daily mean temperature</p>
</div>

</div>

## Stages and periods {#sec:phe-stage-period}

The growth cycle of wheat is started from sowing and finished at harvest ripe.The whole cycle is separated into 10 stages and 10 phases. Wheat jumps into next stage or phase when certian conditions are statisfied (earliness "per se", vernalization and photoperiod).

Stage | Name                      | Description
----- | ------------------------- | -------------------------------------------
1     | Sowing                    | Sow seeds into field
2     | Germination               | Germination begins when the seed imbibes water from the soil and reaches 35 to 45 percent moisture on a dry weight basis
3     | Emergence                 | The coleoptile extends to the soil surface
4     | TerminalSpikelet          | The terminal spikelet initial is formed
5     | FlagLeaf                  | The appearance of flag leaf tip or ligule (??)
6     | Flowering                 | The 50% plants are flowering in the field
7     | StartGrainFill            | Grain filling follows anthesis and refers to the period during which the kernel matures or ripens 
8     | EndGrainFill              | Grain filling follows anthesis and refers to the period during which the kernel matures or ripens
9     | Maturity                  | Grain dry weight reaches its maximum which is correlated to the absence of green color in the chaff or kernels 
10    | HarvestRipe               | Wheat is ready for harvest


Each phase has a targer thermal time (earliness *per se*) and several impact factors to extend the growing period including vernalization, photoperiod, water, nitrogen stresses. 

Name                      | Earliness per se   | Vernalization | Photoperiod | Description
------------------------- | -----------------  | ------------- | ----------- | -------------------------------------------
Germinating               | NA                 | NA            | NA          | Depending on soil water in top layer
Emerging                  | $Lag + Rate*depth$ | NA            | NA          | Depending on the sowing depth        
Vegetative                | NA                 | NA            | NA          | NA
StemElongation            | NA                 | NA            | NA          | NA  
EarlyReproductive         | NA                 | NA            | NA          | NA
GrainDevelopment          | NA                 | NA            | NA          | NA 
GrainFilling              | NA                 | NA            | NA          | NA 
Maturing                  | NA                 | NA            | NA          | NA 
Ripening                  | NA                 | NA            | NA          | NA 
ReadyForHarvesting        | NA                 | NA            | NA          | NA 



<div class="fig-output">

<div class="figure" style="text-align: center">
<img src="phenology_files/figure-html/leaf-tt-stage-1.png" alt="The growthing stage as a function of accumulated thermal  time " width="80%" />
<p class="caption">(\#fig:leaf-tt-stage)The growthing stage as a function of accumulated thermal  time </p>
</div>
</div>


<div class="rmdimportant">
<p>The changing growthing stage in during period 4 looks strange as there are big jump at the start and end of period.</p>
</div>


