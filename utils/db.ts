import { PrismaClient } from "@prisma/client";

const prismaClientSingleton = () => {
    const databaseUrl = process.env.DATABASE_URL;

    // Log SSL configuration for debugging (only when a real DATABASE_URL is available)
    if (process.env.NODE_ENV === "development" && databaseUrl) {
        const url = new URL(databaseUrl);
        console.log(` Database connection: ${url.protocol}//${url.hostname}:${url.port || '3306'}`);
        console.log(`🔒 SSL Mode: ${url.searchParams.get('sslmode') || 'not specified'}`);
    }

    return new PrismaClient({
        // Falls back to a placeholder so the client can be constructed during
        // Next.js's build-time static analysis, where DATABASE_URL isn't set.
        // Real requests always run with a real DATABASE_URL, so this fallback
        // is never actually used to connect.
        datasourceUrl: databaseUrl || "mysql://placeholder:placeholder@localhost:3306/placeholder",
        log: process.env.NODE_ENV === "development"
            ? ['query', 'info', 'warn', 'error']
            : ['error', 'warn'],
    });
}

type PrismaClientSingleton = ReturnType<typeof prismaClientSingleton>;

const globalForPrisma = globalThis as unknown as {
    prisma: PrismaClientSingleton | undefined;
}

const prisma = globalForPrisma.prisma ?? prismaClientSingleton();

export default prisma;

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
