function XC = extract_features_kmeans(X, centroids, rfSize, stride, IMG_DIM, M,P)
  assert(nargin == 5 || nargin == 7);
  whitening = (nargin == 7);
  numCentroids = size(centroids,1);

  if ~exist('stride', 'var')
      stride = [0 0];
  end
  if length(stride) ~= 2
      error('stride must be 1x2');
  end


  % compute features for all training images
  XC = zeros(size(X,1), numCentroids*4);
  for i=1:size(X,1)
    tmp = clock;
    str_time = sprintf('%d-%02d-%02d %02d:%02d', tmp(1), tmp(2), tmp(3), tmp(4), tmp(5));
    fprintf('\n%s: Extracting training features: %d / %d: ', str_time, i, size(X,1));
   if stride
        fprintf('im2colstep... ');
        patches = im2colstep(reshape(X(i, 1:end), IMG_DIM(1:2)), [rfSize rfSize], stride)';
    else
        % TODO: not sure how this works, the element number changes
        % DONE: this is the "sliding window"
        fprintf('im2col... ');
        patches = im2col(reshape(X(i, 1:end), IMG_DIM(1:2)), [rfSize rfSize])';
    end
   % do preprocessing for each patch
    
    % normalize for contrast
    patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));
    % whiten
    if (whitening)
      patches = bsxfun(@minus, patches, M) * P;
    end
    
    % compute 'triangle' activation function
    xx = sum(patches.^2, 2);
    cc = sum(centroids.^2, 2)';
    xc = patches * centroids';
    
    z = sqrt( bsxfun(@plus, cc, bsxfun(@minus, xx, 2*xc)) ); % distances
    [v,inds] = min(z,[],2);
    mu = mean(z, 2); % average distance to centroids for each patch
    patches = max(bsxfun(@minus, mu, z), 0);
    % patches is now the data matrix of activations for each patch
    
     % reshape to 2*numBases-channel image
    %%% quick and dirty
    if stride
	prows = IMG_DIM(1) / stride(1) - 1; %TODO: mathematically incorrect
	pcols = IMG_DIM(2) / stride(2) - 1; %TODO: 
    else
    	prows = IMG_DIM(1)-rfSize+1;
    	pcols = IMG_DIM(2)-rfSize+1;
    end 
   patches = reshape(patches, prows, pcols, numCentroids);
    
    % pool over quadrants
    halfr = round(prows/2);
    halfc = round(pcols/2);
    q1 = sum(sum(patches(1:halfr, 1:halfc, :), 1),2);
    q2 = sum(sum(patches(halfr+1:end, 1:halfc, :), 1),2);
    q3 = sum(sum(patches(1:halfr, halfc+1:end, :), 1),2);
    q4 = sum(sum(patches(halfr+1:end, halfc+1:end, :), 1),2);
    
    % concatenate into feature vector
    XC(i,:) = [q1(:);q2(:);q3(:);q4(:)]';
  end

