function layers = genLayers(outputSize, src, modelPath)
    if strcmp(src, 'caffe_model')
        layers = importCaffeLayers('model.prototxt');
        layers = layers';
    else if strcmp(src, 'checkpoint')
        % TODO
    else
        imageInput = imageInputLayer([32, 32, 3], ...
            'DataAugmentation', 'none', ...
            'Normalization', 'zerocenter', ...
            'Name', 'imageinput');

        conv1 = convolution2dLayer(3, 32, ...
            'Stride', 1, ...
            'Padding', 1, ...
            'NumChannels', 3, ...
            'WeightLearnRateFactor', 1, ...
            'WeightL2Factor', 1, ...
            'BiasLearnRateFactor', 1, ... 
            'BiasL2Factor', 0, ...
            'Name', 'conv_1');
        conv1.Weights = randParams([3 3 3 32], 0);
        conv1.Bias = randParams([1 1 32], 1);

        relu1 = reluLayer('Name', 'relu_1');

        conv2 = convolution2dLayer(3, 32, ...
            'Stride', 1, ...
            'Padding', 1, ...
            'NumChannels', 32, ...
            'WeightLearnRateFactor', 1, ...
            'WeightL2Factor', 1, ...
            'BiasLearnRateFactor', 1, ...
            'BiasL2Factor', 0, ...
            'Name', 'conv_2');
        conv2.Weights = randParams([3 3 32 32], 0);
        conv2.Bias = randParams([1 1 32], 1);

        relu2 = reluLayer('Name', 'relu_2');

        maxpool = maxPooling2dLayer(3, ...
            'Stride', 2, ...
            'Padding', 0, ...
            'Name', 'maxpool');

        fc1 = fullyConnectedLayer(64, ...
            'WeightLearnRateFactor', 1, ...
            'WeightL2Factor', 1, ...
            'BiasLearnRateFactor', 1, ...
            'BiasL2Factor', 0, ...
            'Name', 'fc_1');
        fc1.Weights = randParams([64 7200], 0);
        fc1.Bias = randParams([64 1], 1);

        relu3 = reluLayer('Name', 'relu_3');

        fc2 = fullyConnectedLayer(outputSize, ...
            'WeightLearnRateFactor', 1, ...
            'WeightL2Factor', 1, ...
            'BiasLearnRateFactor', 1, ...
            'BiasL2Factor', 0, ...
            'Name', 'fc_2');
        fc2.Weights = randParams([outputSize 64], 0);
        fc2.Bias = randParams([outputSize 1], 1);

        softmax = softmaxLayer('Name', 'softmax');

        classOutput = classificationLayer('Name', 'classoutput');

        layers = [ ...
            imageInput
            conv1
            relu1
            conv2
            relu2
            maxpool
            fc1
            relu3
            fc2
            softmax
            classOutput];
    end
end
