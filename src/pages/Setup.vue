<template>
    <div class="form-container" data-cy="setup-form">
        <div class="form">
            <form @submit.prevent="submit">
                <div>
                    <object width="64" height="64" data="/icon.svg" />
                    <div style="font-size: 28px; font-weight: bold; margin-top: 5px;">
                        Uptime Kuma
                    </div>
                </div>

                <p class="mt-3">
                    {{ $t("Create your admin account") }}
                </p>

                <div class="form-floating">
                    <select id="language" v-model="$root.language" class="form-select">
                        <option v-for="(lang, i) in $i18n.availableLocales" :key="`Lang${i}`" :value="lang">
                            {{ $i18n.messages[lang].languageName }}
                        </option>
                    </select>
                    <label for="language" class="form-label">{{ $t("Language") }}</label>
                </div>

                <div class="form-floating mt-2">
                    <input id="floatingInput" v-model="username" type="text" class="form-control"
                        :placeholder="$t('Username')" required data-cy="username-input">
                    <label for="floatingInput">{{ $t("Username") }}</label>
                </div>

                <div class="form-floating mt-4">
                    <input id="floatingPassword" v-model="password" type="password" class="form-control"
                        :placeholder="$t('Password')" required data-cy="password-input">
                    <label for="floatingPassword">{{ $t("Password") }}</label>
                </div>

                <div class="form-floating mt-2">
                    <input id="repeat" v-model="repeatPassword" type="password" class="form-control"
                        :placeholder="$t('Repeat Password')" required data-cy="password-repeat-input">
                    <label for="repeat">{{ $t("Repeat Password") }}</label>
                </div>

                <button class="w-100 btn btn-primary mt-2" type="submit" :disabled="processing" data-cy="submit-setup-form">
                    {{ $t("Create") }}
                </button>
            </form>
        </div>
    </div>
</template>

<script>
import { useToast } from "vue-toastification";
const toast = useToast();
import { log } from "../util.ts";
export default {
    data() {
        return {
            processing: false,
            username: "",
            password: "",
            repeatPassword: "",
        };
    },
    watch: {

    },
    mounted() {
        this.$root.getSocket().emit("needSetup", (needSetup) => {
            if (!needSetup) {
                this.$router.push("/");
            }
        });
    },
    methods: {
        /**
         * Submit form data for processing
         * @returns {void}
         */
        submit() {
            this.processing = true;

            if (this.password !== this.repeatPassword) {
                // Inject bug for toast with error in green color
                // toast.error(this.$t("PasswordsDoNotMatch"));
                toast.success(this.$t("PasswordsDoNotMatch"));
                // this.processing = false;
                // Inject bug for input password not match 
                // will disable button submit 
                this.processing = true;
                return;
            }

            this.$root.getSocket().emit("setup", this.username, this.password, (res) => {
                this.processing = false;
                // Inject bug for toast with error in green color
                // and hide toast message when user set up
                // account with valid password has length > 10
                // this.$root.toastRes(res);
                log.info("setup", JSON.stringify(res));
                console.log(res);
                if (res.code === "-1") {
                    console.log(res);
                    log.info("setup", "inject error with password too long: " + JSON.stringify(res));
                    return;
                }
                
                log.info("setup", "inject error with password too long exit if: " + JSON.stringify(res));
                toast.success(res.msg);

                if (res.ok) {
                    this.processing = true;

                    this.$root.login(this.username, this.password, "", () => {
                        this.processing = false;
                        this.$router.push("/");
                    });
                }
            });
        },
    },
};
</script>

<style lang="scss" scoped>
.form-container {
    display: flex;
    align-items: center;
    padding-top: 40px;
    padding-bottom: 40px;
}

.form-floating {
    >.form-select {
        padding-left: 1.3rem;
        padding-top: 1.525rem;
        line-height: 1.35;

        ~label {
            padding-left: 1.3rem;
        }
    }

    >label {
        padding-left: 1.3rem;
    }

    >.form-control {
        padding-left: 1.3rem;
    }
}

.form {

    width: 100%;
    max-width: 330px;
    padding: 15px;
    margin: auto;
    text-align: center;
}
</style>
