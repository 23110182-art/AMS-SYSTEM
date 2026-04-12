package group05.ccmtptpm.ams.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;



@Controller
public class WebController {
    @GetMapping("/login")
    public String loginPage() {
        System.out.println("Accessing login page");
        return "login";
    }
    // Trang cho admin
    @GetMapping("/admin/dashboard")
    public String adminDashboard() {
        return "admin/admin_dashboard";
    }   
    @GetMapping("/admin/types")
    public String adminAssetTypes() {
        return "admin/asset_types";
    }

    @GetMapping("/admin/requests")
    public String adminRequest() {
        return "admin/requests";
    }
    @GetMapping("/admin/assets")
    public String adminAssets() {
        return "admin/assets";
    }
    // Trang cho user
    // @GetMapping("/user/dashboard")
    // public String userDashboard() {
    //     return "user_dashboard";
    // }
    @GetMapping("/user/assets")
    public String userAssets() {
        return "user/assets";
    }
    @GetMapping("/user/request")
    public String userRequest() {
    return "user/request"; 
}
}
