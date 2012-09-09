% txtl_rbs_rbs.m - promoter information for standard RBS
% RMM, 8 Sep 2012
%
% This file contains a description of a standard ribosome binding site.
% Calling the function txtl_rbs_rbs() will set up the reactions for
% translation with the measured binding rates and translation rates.

% Written by Richard Murray, Sep 2012
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

function Rlist = txtl_rbs_rbs(tube, rna, protein)

% Parameters that describe this RBS
%! TODO: replace these values with correct values
kf_rbs = log(2)/0.1;			% 100 ms bind rate
kr_rbs = 100/kf_rbs;			% Km of 0.05 (from VN model)
ktl_rbs = log(2)/(protein.UserData/10);	% 10 AA/second translation

% Create strings for the reactants and products
RNA = ['[' rna.Name ']'];
Ribo = 'Ribo';
Ribobound = ['[' Ribo ':' rna.Name ']'];
Protname = protein.Name;

% Set up the binding reaction
Robj1 = addreaction(tube, [RNA ' + ' Ribo ' <-> ' Ribobound]);
Kobj1 = addkineticlaw(Robj1, 'MassAction');
Pobj1f = addparameter(Kobj1, 'kf', kf_rbs);
Pobj1r = addparameter(Kobj1, 'kr', kr_rbs);
set(Kobj1, 'ParameterVariableNames', {'kf', 'kr'});

% Set up the translation reaction
%! TODO: set translation rate based on length of RNA
Robj2 = addreaction(tube, ...
  [Ribobound ' + AA -> ' RNA ' + ' Protname ' + ' Ribo]);
Kobj2 = addkineticlaw(Robj2, 'MassAction');
Pobj2 = addparameter(Kobj2, 'ktl', ktl_rbs);
set(Kobj2, 'ParameterVariableNames', {'ktl'});

% Return the list of reactions that we set up
Rlist = [Robj1 Robj2];

% Automatically use MATLAB mode in Emacs (keep at end of file)
% Local variables:
% mode: matlab
% End:
