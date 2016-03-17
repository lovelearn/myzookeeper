package com.github.conf.manager.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import com.github.conf.manager.pojo.User;
import com.github.conf.manager.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.conf.manager.IDao.UserMapper;
import com.github.conf.manager.pojo.User;
import com.github.conf.manager.service.UserService;


@Service("userServiceImpl")
public class UserServiceImpl implements UserService {

    @Autowired
    public UserMapper userDao;

    public User getUserById(int id) {
        // TODO Auto-generated method stub
        System.out.println(id + this.userDao.selectId(id).getUsername());

        return this.userDao.selectId(id);
    }


    public Boolean getLoginUser(User userLogin) {
        if ("".equals(userLogin.getUsername()) || ("".equals(userLogin.getPassword()))) {
            return false;
        } else {

            User user = userDao.selectLogin(userLogin.getUsername());
            if (user == null) {
                return false;
            }
            if (userLogin.getPassword().equals(user.getPassword())) {
                return true;
            }
            return false;
        }
    }


    public User user(User user) {
        // TODO Auto-generated method stub
        return null;
    }


    public User selectLogin(String username) {
        // TODO Auto-generated method stub
        return this.userDao.selectLogin(username);
    }


    public User selectByPrimaryKey(int i) {
        // TODO Auto-generated method stub
        return this.userDao.selectByPrimaryKey(i);
    }

    public User getUserByusername(String username) {
        // TODO Auto-generated method stub
        return this.userDao.selectLogin(username);
    }

    public int inster(User user) {
        // TODO Auto-generated method stub
        int i = this.userDao.insert(user);
        return i;
    }

}
