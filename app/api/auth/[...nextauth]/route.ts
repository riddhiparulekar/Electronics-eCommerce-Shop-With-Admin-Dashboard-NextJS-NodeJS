// Source - https://stackoverflow.com/a/77643162
import NextAuth from "next-auth/next";
import { authOptions } from "@/utils/authOptions";

const handler = NextAuth(authOptions);

export { handler as GET, handler as POST };