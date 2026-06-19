import { UserType } from "@prisma/client";

export interface RegisterInput {
  email: string;
  password: string;
  name: string;
  rncCedula: string;
  userType: UserType;
}

export interface LoginInput {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: {
    id: string;
    email: string;
    name: string | null;
    rncCedula: string;
    userType: UserType;
  };
  token: string;
}

export interface JwtPayload {
  userId: string;
  email: string;
  userType: UserType;
}
