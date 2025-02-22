This branch contains useful MATLAB functions for linear control design and analysis.

syms2tf.m: This function converts the symbolic TF matrix with 's' as the only symbolic argument into the TF matrix, usable by MATLAB.

spider_plot.m: This function draws custom spider plots for multi-objective comparative evaluation of control methods.

Robustness.m: This function derives the condition number of the closed-loop linear system as the measure of robustness.

DisturbanceToOutput.m: This function derives the peak singular value of the disturbance-to-output TF matrix (measure of disturbance rejection).

DisturbanceToManInput.m: This function derives the peak singular value of the disturbance-to-manipulated input TF matrix (measure of control effort).

PBCDSyn.mlx: General (Multi-Input) PBCD Synthesis

This function synthesizes the Physics-Based Control Design (PBCD) controller for Multi-Input (MI) linearized plants. It accepts 4 input parameters and outputs 5 parameters. The input parameters are described in the following:
- Plant - a structure that contains symbolic state-space matrices of the small-signal plant, Specs structure with numeric parameters used, and .Syms structure with all symbolic variables used. Note that for small-signal plant, output matrices are such that the output contains only variables to be controlled (not the generalized plant version).
- CascadeOrder - a matrix containing information on the cascaded ordering of the states for control. For example, in a five-state two-input plant, CascadeOrder = [1 3 5;2 4 0] means input 1 controls states , in a cascaded fashion. Input 2 controls states  in a cascaded fashion. SVD analysis is done for automatic cascading order determination. For SISO systems one can use the following function PBCDSyn Subfunctions/SIRealization.m. SVD function for MIMO is TBD.
- Poles - a matrix of positive desired  pole locations in descending order. The setup is such that the resulting PBCD controller  moves the CL poles of  to the  locations. Hence, for stable CL system, Poles  should be defined positive. PBCDSyn assigns the CL poles in descending order from fastest to slowest. Each pole in a matrix corresponds to respective CascadeOrder state. For example if CascadeOrder = [1 3 5;2 4 0], and Poles = [1e3 1e2 1e1; 1e3 1e2 0], it means that input 1/2 cascaded subsystem with states 1,3,5/2,4 is to be tuned for 1e3, 1e2, 1e1/1e3, 1e2 poles respectively.
- Opts.GainCalcMethod - a string that specifies the gain calculation method: Simple, Approximate, Exact. Simple method requires a decade of time-scale separation between closed-loop state dynamics, but is analytically extendable to high-order systems. Exact method numerically (and analytically for low-order systems) calculates the gains such that the CL poles are placed exactly to the desired locations. If the number of poles is greater than 2, analytic calculations become rather cumbersome. Approximate method is in between Simple and Exact in terms of pole-separation vs analytic solvability.
- Opts.Integrator - a logical variable that specifies whether the integrators are to be added to the outermost loops: True/False. If an integrator is added, so far, the integrator gains are calculated simply - outermost poles of respective loops squared divided by Opts.IntegRatio.

The output parameters are described in the following:
- Four structures that contain the synthesized symbolic controller state/input/output/feedthrough matrices Ac.Sym, Bc.Sym, Cc.Sym, Dc.Sym and their numeric evaluations Ac.Num, Bc.Num, Cc.Num, Dc.Num.
- A structure that contains the synthesized symbolic control gains vector K.Sym and its numeric evaluation K.Num. The gains are numerically ordered with gain numbers corresponding to the respective regulated states.

PBCDSyn Subfunctions: functions used in PBCDSyn to explicitly see the PBCDSyn process step-by-step. Every function is extensively commented to explain what it does, its input and output arguments.

SIPBCDSyn.mlx: Single-Input PBCD Synthesis - a simpler version of the PBCDSyn.mlx.
