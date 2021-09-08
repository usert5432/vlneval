#pragma once

#include <string>
#include <memory>

#include "vlneval/struct/VarDict.h"
#include "vlneval/struct/VLNEnergy.h"
#include "vlneval/tf_model/ModelConfig.h"

namespace VLN
{

class TFModel;

const std::vector<InputConfigKeys> DEFAULT_SCALAR_INPUT_KEYS({
    { "input_event", "vars_event" }
});

const std::vector<InputConfigKeys> DEFAULT_VECTOR_INPUT_KEYS({
    { "input_particle", "vars_particle" }
});

const std::vector<std::string> DEFAULT_OUTPUT_KEYS({
    "target_primary", "target_total"
});


/* TODO: Add docs */
class VLNEnergyModel
{
private:
    std::shared_ptr<TFModel> model;

public:
    explicit VLNEnergyModel(
        const std::string &savedir,
        const std::vector<InputConfigKeys> &scalarInputKeys
            = DEFAULT_SCALAR_INPUT_KEYS,
        const std::vector<InputConfigKeys> &vectorInputKeys
            = DEFAULT_VECTOR_INPUT_KEYS,
        const std::vector<std::string> &outputKeys = DEFAULT_OUTPUT_KEYS
    );
    VLNEnergy predict(const VarDict &varDict) const;
};

}

