package com.github.conf.manager.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.github.conf.manager.zk.ZKClientImpl;
import org.apache.zookeeper.CreateMode;
import org.apache.zookeeper.data.Stat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.conf.manager.zk.TreeNodeUtil;

@Controller
@RequestMapping("/zk")
public class ZkController {


    @RequestMapping(value = "/tree.do", method = RequestMethod.GET)
    public String tree(HttpServletRequest request, Model model) {
        String path = request.getParameter("path");
        if (path == null || "".endsWith(path)) {
            path = "/";
        }
        model.addAttribute("path", path);
        model.addAttribute("host", ZKClientImpl.getInstance().ZKHOSTS);
        return "tree";
    }

    @RequestMapping(value = "/children.do", method = RequestMethod.GET)
    public @ResponseBody
    List<Object> children(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path)) {
            path = "/";
        }
        List<String> nodeList = ZKClientImpl.getInstance().getSubNodes(path);
        if ("/".equals(path)) {
            nodeList.remove("zookeeper");
        }

        List<Object> result = TreeNodeUtil.getTreeNodeList(path, nodeList);

        return result;

    }

    @RequestMapping(value = "/getNode.do", method = RequestMethod.GET)
    public String getNode(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path)) {
            path = "/";
        }
        String data = ZKClientImpl.getInstance().getData(path);
        Stat stat = ZKClientImpl.getInstance().getStat(path);

        model.addAttribute("path", path);
        model.addAttribute("data", data);
        model.addAttribute("stat", stat);
        model.addAttribute("user", "admin");
        return "data";
    }

    @RequestMapping(value = "/edit.do", method = RequestMethod.POST)
    public String editNode(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path)) {
            path = "/";
        }
        String data = request.getParameter("new_data");
        String version = request.getParameter("version");
        int versionInt = 0;
        if (!StringUtils.isEmpty(version)) {
            versionInt = Integer.parseInt(version);
        }

        Stat stat = ZKClientImpl.getInstance().updateWithVersion(path, data, versionInt);

        model.addAttribute("path", path);
        model.addAttribute("data", data);
        model.addAttribute("stat", stat);
        model.addAttribute("user", "admin");
        return "data";
    }

    @RequestMapping(value = "/gotoadd.do", method = RequestMethod.GET)
    public String gotoAdd(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path)) {
            path = "/";
        }

        model.addAttribute("path", path);
        model.addAttribute("user", "admin");
        return "create";
    }

    @RequestMapping(value = "/create.do", method = RequestMethod.POST)
    public @ResponseBody
    String createNode(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path.trim()) || "/".equals(path.trim())) {
            return "Create ng";
        }
        String data = request.getParameter("data");
        int type = Integer.parseInt(request.getParameter("flag"));
        CreateMode mode = null;
        switch (type) {
            case 0:
                mode = CreateMode.PERSISTENT;
                break;
            case 1:
                mode = CreateMode.EPHEMERAL;
                break;
            case 2:
                mode = CreateMode.PERSISTENT_SEQUENTIAL;
                break;
            case 3:
                mode = CreateMode.EPHEMERAL_SEQUENTIAL;
                break;
            default:
                break;
        }

        boolean res = ZKClientImpl.getInstance().create(path, data, mode);
        if (res) {
            return "Create ok";
        }
        return "Create ng";
    }

    @RequestMapping(value = "/delete.do", method = RequestMethod.POST)
    public @ResponseBody
    String deleteNode(HttpServletRequest request, Model model) {

        String path = request.getParameter("path");
        if (path == null || "".endsWith(path.trim()) || "/".equals(path.trim())) {
            return "Delete ng";
        }

        boolean res = ZKClientImpl.getInstance().delete(path);
        if (res) {
            return "Delete ok";
        }
        return "Delete ng";
    }

}
