<%-- 
    Document   : loginPage
    Created on : Jun 23, 2023, 9:24:19 AM
    Author     : brenomaistro
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
    <div>
        <div class="card m-2 login-container">
          <div class="card-header">
              <h1 class="logo">&nbsp;Login</h1>
          </div>
          <div class="card-body">
            <form class="m-5">
              <div class="mb-3">
                <label class="form-label">Username</label>
                <input v-model="loginUsername" type="text" class="form-control">
              </div>
              <div class="mb-3">
                <label class="form-label">Password</label>
                <input v-model="loginPassword" type="password" class="form-control">
              </div>
              <button @click="login()" type="submit" class="btn btn-primary">Login</button>
            </form>
          </div>
        </div>
    </div>
    <div v-if="error && error!=='No session'" class="alert alert-danger m-2" role="alert">
        {{error}}
    </div>
</div>
<script>
    const shared = Vue.reactive({ session: null });
    
    const session = Vue.createApp({
        data() {
            return {
                shared: shared,
                error: null,
                loginUsername: null,
                loginPassword: null,
                data: null
            }
        },
        methods: 
        {
            async request(url = "", method, data) 
            {
                try
                {
                    const response = await fetch(url, 
                    {
                        method: method,
                        headers: {"Content-Type": "application/json", },
                        body: JSON.stringify(data)
                    });
                    if(response.status==200)
                    {
                        return response.json();
                    }else
                    {
                        this.error = response.statusText;
                    }
                } catch(e)
                {
                    this.error = e;
                    return null;
                }
            },
            
            async loadSession() 
            {
                const data = await this.request("/Login/api/session", "GET");
                if(data) {this.data = data; this.error = null; this.shared.session = this.data;}
            },
            
            async login() 
            {
                const data = await this.request("/Login/api/session", "PUT", {"login": this.loginUsername, "password": this.loginPassword});
                if(data) {this.data = data; this.error = null; this.shared.session = this.data;}
            },
            
            async logout() 
            {
                const data = await this.request("/Login/api/session", "DELETE");
                if(data) {this.data = null; this.error = null; this.shared.session = this.data;}
            }
        },
        mounted() 
        {
            this.loadSession();
        }
    });
    session.mount('#session');
</script>

<style>
    .login-container {
      max-width: 400px;
      margin: 0 auto;
      margin-top: 100px;
    }
    
    .logo{
      text-align: center;
    }
</style>