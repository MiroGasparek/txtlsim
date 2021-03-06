% txtl_protein_parD.m - protein information for parE
% Zoltan Tuza Jan 2013
%
% This file contains a description of the protein produced by tetR.
% Calling the function txtl_protein_tetR() will set up the reactions for
% sequestration by the inducer aTc.


%
% Copyright (c) 2012 by California Institute of Technology
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%   1. Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%
%   2. Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in the 
%      documentation and/or other materials provided with the distribution.
%
%   3. The name of the author may not be used to endorse or promote products 
%      derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
% IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function varargout = txtl_protein_parE(mode, tube, protein, varargin)
% in 'setup Species' mode, it returns an array of gene lengths, having
% added defaults in places where the lengths are missing. 

% importing the corresponding parameters
paramObj = txtl_component_config('parE');


%%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Species %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(mode.add_dna_driver, 'Setup Species')

    geneData = varargin{1};
    defaultBasePairs = {'parE','lva','terminator';
        paramObj.Gene_Length,paramObj.LVA_tag_Length,paramObj.Terminator_Length};
    geneData = txtl_setup_default_basepair_length(tube,geneData,...
        defaultBasePairs);
    
    varargout{1} = geneData;
    txtl_addspecies(tube, 'protein parEdimerparDdimer', 0, 'Internal');
   
 
    % call other functions in 'Setup Species' mode
    txtl_dimerize(mode, tube,protein);
   
%%%%%%%%%%%%%%%%%%% DRIVER MODE: Setup Reactions %%%%%%%%%%%%%%%%%%%%%%%%%%    
elseif strcmp(mode.add_dna_driver, 'Setup Reactions')
    listOfSpecies = get(tube.species, 'name');
  


    % set up a reaction for protein dimerization
    txtl_dimerize(mode, tube,protein, ...
        [paramObj.Dimmerization_Forward, paramObj.Dimmerization_Reverse]);
    
    % forming Toxin-AntiToxin complex
     txtl_addreaction(tube, ...
         'protein parDdimer + protein parEdimer <-> protein parEdimerparDdimer',...
         'MassAction',{'T-AT_complex_F',0.005;...
                       'T-AT_complex_R',0.1});
    
    
    
%%%%%%%%%%%%%%%%%%% DRIVER MODE: error handling %%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    error('txtltoolbox:txtl_protein_tetR:undefinedmode', ...
      'The possible modes are ''Setup Species'' and ''Setup Reactions''.');
end



% Automatically use MATLAB mode in Emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
