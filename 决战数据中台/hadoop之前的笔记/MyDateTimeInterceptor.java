import javafx.scene.paint.Stop;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.flume.Context;
import org.apache.flume.Event;
import org.apache.flume.interceptor.Interceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**

 * 自定义拦截器-根据用户的访问时间

 * 功能： flume 往hdfs输出数据的时候， 把相同访问时间的数据写入到同一个目录里面

 * 2020-11-02-18
 */
public class MyDateTimeInterceptor implements Interceptor {

    private static final Logger logger = LoggerFactory.getLogger(MyDateTimeInterceptor.class);

    public void initialize() {

    }

    /**

     * 拦截器的核心的方法

     * @param event 参数对象是flume传递过来，代表的是 source 传递过来的原始数据

     * $msec  1604540428.209

     * @return
     */
    public Event intercept(Event event) {
        String data = new String(event.getBody());
        try{

            String[] ds = data.split("#");
            // date: 用户的访问时间
            String date = ds[3];
            date = date.replace(".", "");

            event.getHeaders().put("timestamp", date);



//            String regex1 = "d.*?=";
//            String regex = "&.*?=";

            String request = ds[4];

            request = request.replaceAll(" ","#");
            request = request.replace("?","");
            request = request.replaceAll("d.*?=","#");
            request = request.replaceAll("&.*?=","#");
            ds[4] = request;
            String ds1 = StringUtils.join(ds,"#");
            event.setBody(ds1.getBytes());


        }catch (Exception e){};

        return event;

    }

    /**

     * flume 的批量处理的方法
     * @param events
     * @return
     */
    public List<Event> intercept(List<Event> events) {
        for (Event event : events) {
            intercept(event);
        }
        return events;
    }

    public void close() {

    }

    public static class Builder implements Interceptor.Builder {


        public Interceptor build() {
            return new MyDateTimeInterceptor();
        }

        /**
         * 自定义 flume 配置属性
         * @param context
         */
        public void configure(Context context) {

        }

    }

    public static void main(String[] args) throws Exception{

//        String data = "172.16.0.106#-#-#01/Dec/2020:21:47:09#GET /_utm.gif?domain=mingwang-1&url=http://mingwang-1/unnamed/&title=index&referrer=&sh=864&sw=1536&cd=24&lang=zh-CN HTTP/1.1#404#571#http://mingwang-1/#Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36#-";
//        String[] ds = data.split("####");
//        String regex1 = "d.*?=";
//        String regex = "&.*?=";
//
//        String request = ds[4];
//        System.out.println(request);
//        request = request.replace("?","");
//        request = request.replaceAll(regex,"#");
//        request = request.replaceAll(regex1,"#");
////
//        System.out.println(request);
//
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd hh:MM:SS");
        Date d = sdf.parse("2020-10-27 10:19:00");
        System.out.println(d);

        String a = "1604540428.209".replace(".", "");
        System.out.println(a);
//
//        String data = "192.168.59.1####-####-####1601878264####\"GET / HTTP/1.1\"####304####0####\"-\"####\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36\"####\"-\"";
//        String[] ds = data.split("####");
//        System.out.println(ds[3]);
    }

}