function txtl_mrna_degradation(mode, tube, dna, rna)
    
    txtl_addreaction(tube,[rna.Name ' -> null'],...
        'MassAction',{'TXTL_RNAdeg_F',tube.UserData.ReactionConfig.RNA_deg});
    if mode.utr_attenuator_flag
        txtl_addreaction(tube,['RNA att -> null'],...
            'MassAction',{'TXTL_RNAdeg_F',tube.UserData.ReactionConfig.RNA_deg});
    end
    if mode.utr_rbs_flag
        txtl_addreaction(tube,['AA:ATP:Ribo:' rna.Name ' -> AA + ATP + Ribo'],...
            'MassAction',{'TXTL_RNAdeg_F',tube.UserData.ReactionConfig.RNA_deg});
        txtl_addreaction(tube,['Ribo:' rna.Name ' -> Ribo'],...
            'MassAction',{'TXTL_RNAdeg_F',tube.UserData.ReactionConfig.RNA_deg});
    end


end