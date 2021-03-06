package school.xauat.entity;

import java.util.HashMap;
import java.util.Map;

/**
 * 定义一个类用于封装服务器返回的结果
 */
public class Msg {

    //表示服务器当前响应状态码
    /**
     * 100表示响应成功
     * 200表示响应失败
     */
    private int code;

    //提示信息
    private String msg;

    //表示服务器需要返回给用户的数据
    private Map<String, Object> extend = new HashMap<>();

    public static Msg success() {
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功！");
        return result;
    }

    public static Msg fail() {
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败");
        return result;
    }

    public Msg add(String key, Object obj) {
        this.extend.put(key,obj);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
