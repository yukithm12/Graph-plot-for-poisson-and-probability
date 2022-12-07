String x_name,y_name;
float myu_probability,rou_probability,myu_poisson;
PVector original;
PVector shaft_pixel_x_max,shaft_pixel_y_max;
PVector shaft_pixel_longth; //x,yそれぞれの軸のピクセル距離
PVector data_range_probability,data_max_poisson; //確率分布、ポアソン分布それぞれのデータの最大値

PVector data_poisson_pre;

void setup(){
    size(640,480);
    frameRate(60);

    PFont font = createFont("Meiryo", 50);
    textFont(font);

    original = new PVector(100,height-100);
    shaft_pixel_x_max = new PVector(100,50);
    shaft_pixel_y_max = new PVector(width-100,height-100);
    shaft_pixel_longth = new PVector();
    shaft_pixel_longth.x = abs(shaft_pixel_x_max.y - original.y);
    shaft_pixel_longth.y = abs(shaft_pixel_y_max.x - original.x);
    data_range_probability = new PVector(20,0.3);
    data_max_poisson = new PVector(20,0.3);
    myu_probability = 4;
    rou_probability = 2;
    myu_poisson = 4;

    data_poisson_pre = new PVector();
}

void draw(){
    background(250);
    smooth();

    //0・・・確率分布、1・・・ポアソン分布
    graphStart(1);
    graphDraw(0);
    graphDraw(1);
}

void graphStart(int state){   
    PVector memory_num_probability = new PVector(9,11);
    PVector memory_num_poisson = new PVector(9,5);
    PVector data_text_size = new PVector(30,15);
    float memory_size = 10;
    PVector memory_name_d = new PVector(50,30); //テキスト中央からの距離
    PVector memory_data_d = new PVector(40,30);

    //軸の描画
    line(original.x,original.y,shaft_pixel_x_max.x,shaft_pixel_x_max.y);
    line(original.x,original.y,shaft_pixel_y_max.x,shaft_pixel_y_max.y);

    if(state == 0){
        //y軸メモリの描画
        for(int i=0; i<memory_num_probability.x; i++){
            float yoff = original.y - i*(shaft_pixel_longth.x/(memory_num_probability.x-1));
            line(original.x,yoff,original.x+memory_size,yoff);

            //System.out.println("A");
            //y軸メモリのデータの描画
            float data_y_float = (float)round(((float)i*(data_range_probability.y/(memory_num_probability.x-1)))*100)/100;
            String data_y = String.valueOf(data_y_float);
            textSize(12);
            textAlign(CENTER,CENTER);
            fill(0);
            text(data_y,original.x-memory_data_d.x,yoff);
        }

        //x軸メモリの描画
        for(int i=0; i<memory_num_probability.y; i++){
            float xoff =original.x + i*(shaft_pixel_longth.y/(memory_num_probability.y-1));
            line(xoff,original.y,xoff,original.y-memory_size);

            //x軸メモリのデータの描画
            float data_x_float = (float)round(((float)(i-(memory_num_probability.y-1)/2)*(data_range_probability.x/(memory_num_probability.y-1)))*100)/100;
            String data_x = String.valueOf(data_x_float);
            textSize(12);
            textAlign(CENTER,CENTER);
            fill(0);
            text(data_x,xoff,original.y+memory_data_d.y);
        }

        textSize(24);
        textAlign(LEFT,TOP);
        fill(0);
        text("確率分布",textWidth("ポアソン分布")+80,0);

        /*textSize(12);
        textAlign(CENTER,CENTER);
        fill(0);
        text()*/
    }

    else if(state == 1){
        //y軸メモリの描画
        for(int i=0; i<memory_num_poisson.x; i++){
            float yoff = original.y - i*(shaft_pixel_longth.x/(memory_num_poisson.x-1));
            line(original.x,yoff,original.x+memory_size,yoff);

            //System.out.println("A");
            //y軸メモリのデータの描画
            float data_y_float = (float)round(((float)i*(data_max_poisson.y/(memory_num_poisson.x-1)))*100)/100;
            String data_y = String.valueOf(data_y_float);
            textSize(12);
            textAlign(CENTER,CENTER);
            fill(0);
            text(data_y,original.x-memory_data_d.x,yoff);
        }

        //x軸メモリの描画
        for(int i=0; i<memory_num_probability.y; i++){
            float xoff =original.x + i*(shaft_pixel_longth.y/(memory_num_poisson.y-1));
            line(xoff,original.y,xoff,original.y-memory_size);

            //x軸メモリのデータの描画
            float data_x_float = (float)round(((float)i*(data_max_poisson.x/(memory_num_poisson.y-1)))*100)/100;
            String data_x = String.valueOf(data_x_float);
            textSize(12);
            textAlign(CENTER,CENTER);
            fill(0);
            text(data_x,xoff,original.y+memory_data_d.y);
        }

        textSize(24);
        textAlign(LEFT,TOP);
        fill(0);
        text("ポアソン分布",0,0);
        colorMode(HSB,360,100,100);
        stroke(60,80,80);
        line(textWidth("ポアソン分布")+20,20,textWidth("ポアソン分布")+60,20);

        fill(0);
        text("確率分布",textWidth("ポアソン分布")+80,0);
        stroke(0,80,80);
        line(textWidth("ポアソン分布")+textWidth("確率分布")+100,20,textWidth("ポアソン分布")+textWidth("確率分布")+140,20);
        colorMode(RGB);

        textSize(15);
        textAlign(LEFT,CENTER);
        fill(0);
        text("確率P",5,height/2-40);

        textSize(15);
        textAlign(CENTER,CENTER);
        fill(0);
        text("N回起こる",width/2,height/2+200);
    }
}

//確率分布計算式
float probabilityDistribution(float x){
    float y = (1/(sqrt(2*PI)*rou_probability))*exp(-(pow(x-myu_probability,2)/(2*pow(rou_probability,2))));
    return y;
}

//ポアソン分布計算式
float PoissonDistribution(float n){
    float y = (exp(-myu_poisson)*pow(myu_poisson,n))/factorial_recursive(n);
    return y;
}

//ピクセル単位からメモリ単位に変換
float pixelToMemory(float before,float data_max){
    float after = before * (shaft_pixel_longth.x / data_max);

    return after;
}

//メモリ単位からピクセル単位に変換
float memoryToPixel(float before,float data_max){
    float after = data_max * (before/shaft_pixel_longth.y);
    return after;
}

void graphDraw(int state){
    if(state==0){
        //確率分布のグラフを描画
        for(int i=0; i<shaft_pixel_longth.y; i++){
            float i_float = (float)i;
            float data_i = memoryToPixel(i_float,data_max_poisson.x);

            float y = probabilityDistribution(data_i);

            float result = pixelToMemory(y,data_max_poisson.y);
            
            PVector result_display = new PVector();
            result_display.x = original.x+i;
            result_display.y = original.y-result;

            colorMode(HSB,360,100,100);
            float c = map(result,0,shaft_pixel_longth.x,0,100);
            fill(0,80,80);
            noStroke();
            ellipse(result_display.x,result_display.y,2,2);
            fill(0);
            stroke(0);
            colorMode(RGB);
        }
    }

    if(state==1){
        //確率分布のグラフを描画
        for(int i=0; i<20; i++){
            float n = (float)i * (shaft_pixel_longth.y/20);
            float data_n = memoryToPixel(n,data_max_poisson.x);

            float y = PoissonDistribution(data_n);

            float result = pixelToMemory(y,data_max_poisson.y);
            
            PVector result_display = new PVector();
            result_display.x = original.x+n;
            result_display.y = original.y-result;

            colorMode(HSB,360,100,100);
            float c = map(result,0,shaft_pixel_longth.x,0,100);
            fill(60,80,80);
            noStroke();
            ellipse(result_display.x,result_display.y,7,7);
            if(i!=0){
                stroke(60,80,80);
                line(data_poisson_pre.x,data_poisson_pre.y,result_display.x,result_display.y);
            }
            data_poisson_pre.set(result_display);
            fill(0);
            stroke(0);
            colorMode(RGB);
        }
    }
}

float factorial_recursive(float i){
    if(i < 0){
        println("Error! Invarid input.<using recursive>");
        return -1;
    } else if(i == 0){
        return 1;
    } else {
        return i * factorial_recursive(i - 1);
    }
}   
