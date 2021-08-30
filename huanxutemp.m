function result = huanxutemo(M )

    temp = M(,:);
    M(,:) = M(,:);
    M(,:) = temp;

    result = M;