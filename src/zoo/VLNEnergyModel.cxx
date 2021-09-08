#include "vlneval/zoo/VLNEnergyModel.h"
#include "tf_model/TFModel.h"

#include "tensorflow/core/public/session.h"
#include "tensorflow/core/platform/env.h"

namespace VLN
{

VLNEnergyModel::VLNEnergyModel(
    const std::string &savedir,
    const std::vector<InputConfigKeys> &scalarInputKeys,
    const std::vector<InputConfigKeys> &vectorInputKeys,
    const std::vector<std::string> &outputKeys
) :
    model(std::make_shared<TFModel>(
        savedir, scalarInputKeys, vectorInputKeys, outputKeys
    ))
{ }

VLNEnergy VLNEnergyModel::predict(const VarDict &vars) const
{
    std::vector<tensorflow::Tensor> outputs = model->predict(vars);

    const float primaryE = outputs[0].tensor<float,2>()(0, 0);
    const float totalE   = outputs[1].tensor<float,2>()(0, 0);

    return VLNEnergy{ primaryE, totalE };
}

}
