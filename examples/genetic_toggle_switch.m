% Genetic Toggle Switch example
% Vipul Singhal, September 2012
%
% This file contains a simple example of setting up a TXTL simulation
% for a genetic switch. It shows the bistability of the circuit, and the
% switching that can be accomplished by the tetR repressing inducer aTc and
% the lacI repressing inducer IPTG. 

% the dimerization and tetramerization rates of lacI and tetR here are
% high. need to check what the actual values are, since that is intimitaly
% related to the working of this switch. 
% another thing to be played with (and hence should be told to anyone who
% uses this simulation, is that TX and TL rates might be mo

% clean up
%close all
clearvars

% define plasmid concentration
ptet_DNA = 4; % nM
placI_DNA = 1; % nM

% set up the tubes
tube1 = txtl_extract('E30VNPRL');
tube2 = txtl_buffer('E30VNPRL');
tube3 = txtl_newtube('genetics_switch');

% add dna to tube3
dna_lacI = txtl_add_dna(tube3,'ptet(50)', 'rbs(20)', 'lacI(647)', ptet_DNA, 'plasmid');
dna_tetR = txtl_add_dna(tube3, 'plac(50)', 'rbs(20)', 'tetR(647)', placI_DNA, 'plasmid');
% dna_deGFP = txtl_add_dna(tube3, 'ptet(50)', 'rbs(20)', 'deGFP(1000)', ptet_DNA, 'plasmid');
% dna_deCFP = txtl_add_dna(tube3, 'placI(50)', 'rbs(20)', 'deCFP(1000)', placI_DNA, 'plasmid');

% combine extact, buffer and dna into one tube
Mobj = txtl_combine([tube1, tube2, tube3]);

% add inducers
txtl_addspecies(Mobj, 'aTc',1000);
txtl_addspecies(Mobj, 'IPTG',0);

% set up simulation
simulationTime = 8*60*60; % hours

% simulate the reaction
tic 
simData = txtl_runsim(Mobj,simulationTime);
toc

t_ode = simData.Time;
x_ode = simData.Data;

% plot data
dataGroups = txtl_getDefaultPlotDataStruct();

dataGroups(2).SpeciesToPlot = {'[protein lacItetramer]_tot','[protein tetRdimer]_tot'};

txtl_plot(t_ode,x_ode,Mobj,dataGroups);

