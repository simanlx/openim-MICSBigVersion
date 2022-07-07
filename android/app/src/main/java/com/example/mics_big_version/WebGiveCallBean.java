package com.example.mics_big_version;

import java.util.List;

public class WebGiveCallBean {

    private boolean type;
    private List<WebGiveCallBeanItem> callList;

    public boolean isType() {
        return type;
    }

    public void setType(boolean type) {
        this.type = type;
    }

    public List<WebGiveCallBeanItem> getCallList() {
        return callList;
    }

    public void setCallList(List<WebGiveCallBeanItem> callList) {
        this.callList = callList;
    }

    public static class WebGiveCallBeanItem{
        private String id;
        private String account;
        private String name;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getAccount() {
            return account;
        }

        public void setAccount(String account) {
            this.account = account;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

}
