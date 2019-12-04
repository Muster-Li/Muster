一、WebMvcConfigurerAdapter是什么
Spring内部的一种配置方式
采用JavaBean的形式来代替传统的xml配置文件形式进行针对框架个性化定制

二、WebMvcConfigurerAdapter常用的方法
/** 解决跨域问题 **/
public void addCorsMappings(CorsRegistry registry) ;

/** 添加拦截器 **/
void addInterceptors(InterceptorRegistry registry);

/** 这里配置视图解析器 **/
void configureViewResolvers(ViewResolverRegistry registry);

/** 配置内容裁决的一些选项 **/
void configureContentNegotiation(ContentNegotiationConfigurer configurer);

/** 视图跳转控制器 **/
void addViewControllers(ViewControllerRegistry registry);

/** 静态资源处理 **/
void addResourceHandlers(ResourceHandlerRegistry registry);

/** 默认静态资源处理器 **/
void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer)
 

1、addInterceptors：拦截器

addInterceptor：需要一个实现HandlerInterceptor接口的拦截器实例
addPathPatterns：用于设置拦截器的过滤路径规则
excludePathPatterns：用于设置不需要拦截的过滤规则
@Override
public void addInterceptors(InterceptorRegistry registry) {
    super.addInterceptors(registry);
    registry.addInterceptor(new TestInterceptor()).addPathPatterns("/**");
}

2、addCorsMappings：跨域

@Override
public void addCorsMappings(CorsRegistry registry) {
    super.addCorsMappings(registry);
    registry.addMapping("/cors/**")
            .allowedHeaders("*")
            .allowedMethods("POST","GET")
            .allowedOrigins("*");
}
3、addViewControllers：跳转指定页面

@Override
 public void addViewControllers(ViewControllerRegistry registry) {
     super.addViewControllers(registry);
     registry.addViewController("/").setViewName("/index");
     //实现一个请求到视图的映射，而无需书写controller
     registry.addViewController("/login").setViewName("forward:/index.html");  
}
4、resourceViewResolver：视图解析器

/**
 * 配置请求视图映射
 * @return
 */
@Bean
public InternalResourceViewResolver resourceViewResolver()
{
    InternalResourceViewResolver internalResourceViewResolver = new InternalResourceViewResolver();
    //请求视图文件的前缀地址
    internalResourceViewResolver.setPrefix("/WEB-INF/jsp/");
    //请求视图文件的后缀
    internalResourceViewResolver.setSuffix(".jsp");
    return internalResourceViewResolver;
}

/**
 * 视图配置
 * @param registry
 */
@Override
public void configureViewResolvers(ViewResolverRegistry registry) {
    super.configureViewResolvers(registry);
    registry.viewResolver(resourceViewResolver());
    /*registry.jsp("/WEB-INF/jsp/",".jsp");*/
}
5、configureMessageConverters：信息转换器

/**
* 消息内容转换配置
 * 配置fastJson返回json转换
 * @param converters
 */
@Override
public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
    //调用父类的配置
    super.configureMessageConverters(converters);
    //创建fastJson消息转换器
    FastJsonHttpMessageConverter fastConverter = new FastJsonHttpMessageConverter();
    //创建配置类
    FastJsonConfig fastJsonConfig = new FastJsonConfig();
    //修改配置返回内容的过滤
    fastJsonConfig.setSerializerFeatures(
            SerializerFeature.DisableCircularReferenceDetect,
            SerializerFeature.WriteMapNullValue,
            SerializerFeature.WriteNullStringAsEmpty
    );
    fastConverter.setFastJsonConfig(fastJsonConfig);
    //将fastjson添加到视图消息转换器列表内
    converters.add(fastConverter);

}
6、addResourceHandlers：静态资源

@Override
 public void addResourceHandlers(ResourceHandlerRegistry registry) {
     //处理静态资源的，例如：图片，js，css等
     registry.addResourceHandler("/resource/**").addResourceLocations("/WEB-INF/static/");
 }
三、WebMvcConfigurerAdapter使用方式
1、过时方式：继承WebMvcConfigurerAdapter
Spring 5.0 以后WebMvcConfigurerAdapter会取消掉
WebMvcConfigurerAdapter是实现WebMvcConfigurer接口
@Configuration

public class WebConfig extends WebMvcConfigurerAdapter {

//TODO

}

2、现用方式
1）实现WebMvcConfigurer
@Configuration

public class WebMvcConfg implements WebMvcConfigurer {

//TODO

}

 

2）现用方式：继承WebMvcConfigurationSupport
@Configuration

public class WebMvcConfg extends WebMvcConfigurationSupport {

//TODO

}
