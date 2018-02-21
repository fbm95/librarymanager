package com.example.books.dto;

public class Department {
    private final int deptno;
    private final String dname;
    private final String loc;

    public Department(int deptno, String dname, String loc){
        this.deptno=deptno;
        this.dname=dname;
        this.loc=loc;
    }

    public long getDeptno() {
        return deptno;
    }

    public String getDname() {
        return dname;
    }

    public String getLoc() {
        return loc;
    }

}
